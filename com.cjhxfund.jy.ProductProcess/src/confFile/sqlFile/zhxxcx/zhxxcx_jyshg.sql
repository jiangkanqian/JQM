----综合信息查询SQL-交易所回购：信息查询-综合信息查询-交易所回购[8]
--需要字段：基金名称，组合名称，回购代码，委托方向，数量，净资金额，平均利率，利润，回购日期，实际购回日期，购回交割日期，实际占款天数
/**交易所存续回购**/
select L_HG_DATE, --回购日期
       L_FUND_ID, --基金ID
       VC_FUND_CODE, --基金代码
       VC_FUND_NAME, --基金名称
       VC_COMBI_NO, --组合代码
       VC_COMBI_NAME, --组合名称
       VC_REPORT_CODE, --回购代码
       VC_ENTRUSTDIR_NAME, --委托方向
       L_DEAL_AMOUNT, --数量
       EN_NET_ZJ, --净资金额
       EN_INTEREST_RATE, --平均利率
       EN_PROFIT, --利润
       L_REDEEM_LIQUIDATE, --实际购回日期
       L_SETTLE_DATE, --购回交割日期
       L_USE_DAYS --实际占款天数
  from (
select
 to_char(a.l_hg_date) l_hg_date,
 sum(a.EN_FEE) EN_FEE,
 (select tinfo.vc_fund_code from trade.tfundinfo tinfo where tinfo.l_fund_id=a.l_fund_id) vc_fund_code,
 min(a.L_REDEEM_DAYS) L_REDEEM_DAYS,
 min(a.c_market_no) c_market_no,
 min(a.EN_DEAL_PRICE) EN_DEAL_PRICE,
 to_char(nvl(a.l_redeem_lawdate, 0)) l_redeem_lawdate,
 to_char(nvl(a.l_redeem_liquidate, 0)) l_redeem_liquidate,
 Decode(Sum(a.l_Deal_Amount),
        0,
        0,
        Sum(a.En_Deal_Price * a.l_Deal_Amount) / Sum(a.l_Deal_Amount)) *
 Max(decode(nvl(to_date(a.L_SETTLE_DATE, 'YYYYMMDD') -
                (Select Min(to_date(Tm.l_Date, 'YYYYMMDD'))
                   From trade.Tmarkettradeday Tm
                  Where Tm.l_Date > a.l_Hg_Date
                    And tm.Vc_Tradeday_Type = j.vc_tradeday_type
                    and Tm.c_Trade_Flag In ('1', '3')),
                0),
            0,
            0,
            a.l_redeem_days /
            (to_date(a.L_SETTLE_DATE, 'YYYYMMDD') -
            (Select Min(to_date(Tm.l_Date, 'YYYYMMDD'))
                From trade.Tmarkettradeday Tm
               Where Tm.l_Date > a.l_Hg_Date
                 and tm.Vc_Tradeday_Type = j.vc_tradeday_type
                 And Tm.c_Trade_Flag In ('1', '3'))))) En_real_Interest_Rate,
 case
   when c.c_stock_type = '-' then
    max(case
          when (a.L_REDEAL_DATE <> 0) and (a.C_REDEAL_FLAG = '1') then
           trade.sf_date_diff(a.l_hg_date, a.L_REDEAL_DATE)
          when (to_number(to_char(sysdate, 'YYYYMMDD')) > a.L_REDEEM_LIQUIDATE) and
               (a.C_REDEAL_FLAG = '0') then
           trade.sf_date_diff(a.l_hg_date, to_number(to_char(sysdate, 'YYYYMMDD')))
          else
           trade.sf_date_diff(a.l_Hg_Date, a.L_SETTLE_DATE)
        end)
   else
    nvl(Max(to_date(a.L_SETTLE_DATE, 'YYYYMMDD') -
            (Select Min(to_date(Tm.l_Date, 'YYYYMMDD'))
               From trade.Tmarkettradeday Tm
              Where Tm.l_Date > a.l_Hg_Date
                And tm.Vc_Tradeday_Type = j.vc_tradeday_type
                and Tm.c_Trade_Flag In ('1', '3'))),
        0)
 end L_USE_DAYS,
 to_char(nvl(a.l_settle_date, 0)) l_settle_date,
 to_char(nvl(a.l_redeal_date, 0)) l_redeal_date,
 a.l_settle_speed,
 c.vc_report_code,
 min(j.vc_market_name) vc_market_name,
 min(c.vc_stock_name) vc_stock_name,
 sum(decode(b.c_fund_direction, '1', -1, 1) * a.l_deal_amount) l_deal_amount,
 case
   when c.c_stock_type = '-' then
    min(a.en_deal_price)
   else
    Decode(sum(a.l_deal_amount),
           0,
           0,
           sum(a.en_deal_price * a.l_deal_amount) / sum(a.l_deal_amount))
 end en_interest_rate,
 sum(decode(b.c_fund_direction, '1', 1, -1) * a.en_deal_balance - a.en_fee) en_net_zj,
 sum(decode(b.c_fund_direction, '1', -1, 1) *
     (a.en_deal_balance + a.en_redeem_interest)) en_ret_zj,
 sum(decode(b.c_fund_direction, '1', -1, 1) * a.en_redeem_interest -
     a.en_fee) en_profit,
 sum(decode(b.c_entrust_direction, '5', -1, 1) * a.en_now_interest) en_now_interest,
 sum(a.en_redeem_interest - a.en_fee -
     (a.en_deal_balance + a.en_fee) *
     nvl(nvl((select en_year_rate / l_days
               from trade.TINTERESTRATE
              where vc_currency_no = 'CNY'
                and l_rate_type = '1'
                and l_fund_id = a.l_fund_id),
             (select en_year_rate / l_days
                from trade.TINTERESTRATE
               where vc_currency_no = 'CNY'
                 and l_rate_type = '1'
                 and l_fund_id = -1)),
         0) *
     decode(a.l_redeem_days,
            3,
            decode(to_number(to_char(to_date(to_char(a.l_date, 99999999),
                                             'yyyymmdd'),
                                     'd')),
                   2,
                   3,
                   3,
                   5,
                   4,
                   5,
                   5,
                   4,
                   6,
                   1,
                   a.l_redeem_days),
            a.l_redeem_days)) en_extra_profit,
 b.vc_entrustdir_name,
 a.C_ENTRUST_DIRECTION,
 c.c_stock_type,
 b.c_stock_direction,
 a.c_redeal_flag,
 (case
   when count(distinct(a.l_fund_id)) = 1 then
    min(a.l_fund_id)
   else
    -1
 end) l_fund_id,
 (case
   when count(distinct(a.l_basecombi_id)) = 1 then
    min(e.vc_combi_no)
   else
    '混合'
 end) vc_combi_no,
 (case
   when count(distinct(d.l_fund_id)) = 1 then
    min(d.vc_fund_name)
   else
    '混合'
 end) vc_fund_name,
 (case
   when count(distinct(a.l_basecombi_id)) = 1 then
    min(e.vc_combi_name)
   else
    '混合'
 end) vc_combi_name,
 (case
   when count(distinct(h.l_asset_id)) = 1 then
    min(h.l_asset_id)
   else
    -1
 end) l_asset_id,
 (case
   when count(distinct(a.vc_stockholder_id)) = 1 then
    min(a.vc_stockholder_id)
   else
    '混合'
 end) vc_stockholder_id,
 (case
   when count(distinct(h.l_asset_id)) = 1 then
    min(h.vc_asset_name)
   else
    '混合'
 end) vc_asset_name,
 (case
   when count(distinct(h.l_asset_id)) = 1 then
    min(h.vc_asset_no)
   else
    '混合'
 end) vc_asset_no,
 (case
   when count(distinct(a.l_operator_no)) = 1 then
    to_char(min(a.l_operator_no))
   else
    '-1'
 end) l_operator_no,
 (case
   when count(distinct(a.l_basecombi_id)) = 1 then
    min(a.l_basecombi_id)
   else
    -1
 end) l_basecombi_id,
 '' as vc_settle_oper_name
  from trade.THGREGISTER       a,
       trade.TENTRUSTDIRECTION b,
       trade.TSTOCKINFO        c,
       trade.TFUNDINFO         d,
       trade.TCOMBI            e,
       trade.TASSET            h,
       trade.tmarketinfo       j
 where a.c_entrust_direction = b.c_entrust_direction
   and a.c_market_no = b.c_market_no
   and a.vc_inter_code = c.vc_inter_code
   and a.l_fund_id = d.l_fund_id
   and a.l_basecombi_id = e.l_combi_id
   and a.c_market_no = j.c_market_no
   and a.c_market_no in ('1', '2')
   and e.l_asset_id = h.l_asset_id
   and e.c_combi_status not in ('2', '3')
   and c.c_stock_type not in ('x', 'A')
   and (a.c_redeal_flag = '0' or
       (a.c_redeal_flag = '1' and
       decode(nvl(a.L_REDEAL_DATE, 0),
                0,
                a.L_REDEEM_LIQUIDATE,
                a.L_REDEAL_DATE) = PARAM_BUSI_DATE_TODAY))
 group by a.l_hg_date,
          l_redeem_lawdate,
          a.l_redeem_liquidate,
          a.l_settle_date,
          a.l_redeal_date,
          a.l_settle_speed,
          c.vc_report_code,
          a.C_ENTRUST_DIRECTION,
          b.vc_entrustdir_name,
          c.c_stock_type,
          b.c_stock_direction,
          a.c_redeal_flag,
          a.l_fund_id,
          d.vc_fund_name,
          h.l_asset_id,
          h.vc_asset_name,
          e.vc_combi_no,
          a.l_basecombi_id,
          e.vc_combi_name,
          a.vc_stockholder_id,
          a.l_operator_no
union all
select to_char(a.l_hg_date) l_hg_date,
       sum(a.EN_FEE) EN_FEE,
        (select tinfo.vc_fund_code from trade.tfundinfo tinfo where tinfo.l_fund_id=a.l_fund_id) vc_fund_code,
       min(a.L_REDEEM_DAYS) L_REDEEM_DAYS,
       min(a.c_market_no) c_market_no,
       min(a.EN_DEAL_PRICE) EN_DEAL_PRICE,
       to_char(nvl(a.l_redeem_lawdate, 0)) l_redeem_lawdate,
       to_char(nvl(a.l_redeem_liquidate, 0)) l_redeem_liquidate,
       Decode(Sum(a.l_Deal_Amount),
              0,
              0,
              Sum(a.En_Deal_Price * a.l_Deal_Amount) / Sum(a.l_Deal_Amount)) *
       Max(decode(nvl((to_date(a.L_SETTLE_DATE, 'YYYYMMDD') -
                      (Select Min(to_date(Tm.l_Date, 'YYYYMMDD'))
                          From trade.Tmarkettradeday Tm
                         Where Tm.l_Date > a.l_Hg_Date
                           And tm.Vc_Tradeday_Type = j.vc_tradeday_type
                           and Tm.c_Trade_Flag In ('1', '3'))),
                      0),
                  0,
                  0,
                  a.l_redeem_days /
                  (to_date(a.L_SETTLE_DATE, 'YYYYMMDD') -
                  (Select Min(to_date(Tm.l_Date, 'YYYYMMDD'))
                      From trade.Tmarkettradeday Tm
                     Where Tm.l_Date > a.l_Hg_Date
                       And tm.Vc_Tradeday_Type = j.vc_tradeday_type
                       and Tm.c_Trade_Flag In ('1', '3'))))) En_real_Interest_Rate,
       case
         when c.c_stock_type = '-' then
          nvl(Max(to_date(decode(nvl(a.l_redeal_date, 0),
                                 0,
                                 a.L_REDEEM_LIQUIDATE,
                                 a.l_redeal_date),
                          'YYYYMMDD') - to_date(a.l_Hg_Date, 'YYYYMMDD')),
              0)
         else
          nvl(Max(to_date(a.L_SETTLE_DATE, 'YYYYMMDD') -
                  (Select Min(to_date(Tm.l_Date, 'YYYYMMDD'))
                     From trade.Tmarkettradeday Tm
                    Where Tm.l_Date > a.l_Hg_Date
                      And tm.Vc_Tradeday_Type = j.vc_tradeday_type
                      and Tm.c_Trade_Flag In ('1', '3'))),
              0)
       end L_USE_DAYS,
       to_char(nvl(a.l_settle_date, 0)) l_settle_date,
       to_char(nvl(a.l_redeal_date, 0)) l_redeal_date,
       a.l_settle_speed,
       c.vc_report_code,
       min(j.vc_market_name) vc_market_name,
       min(c.vc_stock_name) vc_stock_name,
       sum(decode(b.c_fund_direction, '1', -1, 1) * a.l_deal_amount) l_deal_amount,
       case
         when c.c_stock_type = '-' then
          min(a.en_deal_price)
         else
          Decode(sum(a.l_deal_amount),
                 0,
                 0,
                 sum(a.en_deal_price * a.l_deal_amount) /
                 sum(a.l_deal_amount))
       end en_interest_rate,
       sum(decode(b.c_fund_direction, '1', 1, -1) * a.en_deal_balance -
           a.en_fee) en_net_zj,
       sum(decode(b.c_fund_direction, '1', -1, 1) *
           (a.en_deal_balance + a.en_redeem_interest)) en_ret_zj,
       sum(decode(b.c_fund_direction, '1', -1, 1) * a.en_redeem_interest -
           a.en_fee) en_profit,
       sum(decode(b.c_entrust_direction, '5', -1, 1) * a.en_now_interest) en_now_interest,
       sum(a.en_redeem_interest - a.en_fee -
           (a.en_deal_balance + a.en_fee) *
           nvl(nvl((select en_year_rate / l_days
                     from trade.TINTERESTRATE
                    where vc_currency_no = 'CNY'
                      and l_rate_type = '1'
                      and l_fund_id = a.l_fund_id),
                   (select en_year_rate / l_days
                      from trade.TINTERESTRATE
                     where vc_currency_no = 'CNY'
                       and l_rate_type = '1'
                       and l_fund_id = -1)),
               0) * decode(a.l_redeem_days,
                           3,
                           decode(to_number(to_char(to_date(to_char(a.l_date,
                                                                    99999999),
                                                            'yyyymmdd'),
                                                    'd')),
                                  2,
                                  3,
                                  3,
                                  5,
                                  4,
                                  5,
                                  5,
                                  4,
                                  6,
                                  1,
                                  a.l_redeem_days),
                           a.l_redeem_days)) en_extra_profit,
       b.vc_entrustdir_name,
       a.C_ENTRUST_DIRECTION,
       c.c_stock_type,
       b.c_stock_direction,
       a.c_redeal_flag,
       (case
         when count(distinct(a.l_fund_id)) = 1 then
          min(a.l_fund_id)
         else
          -1
       end) l_fund_id,
       (case
         when count(distinct(a.l_basecombi_id)) = 1 then
          min(e.vc_combi_no)
         else
          '混合'
       end) vc_combi_no,
       (case
         when count(distinct(d.l_fund_id)) = 1 then
          min(d.vc_fund_name)
         else
          '混合'
       end) vc_fund_name,
       (case
         when count(distinct(a.l_basecombi_id)) = 1 then
          min(e.vc_combi_name)
         else
          '混合'
       end) vc_combi_name,
       (case
         when count(distinct(h.l_asset_id)) = 1 then
          min(h.l_asset_id)
         else
          -1
       end) l_asset_id,
       (case
         when count(distinct(a.vc_stockholder_id)) = 1 then
          min(a.vc_stockholder_id)
         else
          '混合'
       end) vc_stockholder_id,
       (case
         when count(distinct(h.l_asset_id)) = 1 then
          min(h.vc_asset_name)
         else
          '混合'
       end) vc_asset_name,
       (case
         when count(distinct(h.l_asset_id)) = 1 then
          min(h.vc_asset_no)
         else
          '混合'
       end) vc_asset_no,
       (case
         when count(distinct(a.l_operator_no)) = 1 then
          to_char(min(a.l_operator_no))
         else
          '-1'
       end) l_operator_no,
       (case
         when count(distinct(a.l_basecombi_id)) = 1 then
          min(a.l_basecombi_id)
         else
          -1
       end) l_basecombi_id,
       '' as vc_settle_oper_name
  from trade.ThisHGREGISTER    a,
       trade.TENTRUSTDIRECTION b,
       trade.ThisSTOCKINFO     c,
       trade.TFUNDINFO         d,
       trade.TCOMBI            e,
       trade.TASSET            h,
       trade.tmarketinfo       j
 where a.c_entrust_direction = b.c_entrust_direction
   and a.c_market_no = b.c_market_no
   and a.l_hg_date = c.l_date
   and a.vc_inter_code = c.vc_inter_code
   and a.l_fund_id = d.l_fund_id
   and a.l_basecombi_id = e.l_combi_id
   and a.c_market_no = j.c_market_no
   and a.c_market_no in ('1', '2')
   and e.l_asset_id = h.l_asset_id
   and e.c_combi_status not in ('2', '3')
   and c.c_stock_type not in ('x', 'A')
   and a.c_redeal_flag <> '1'
 group by a.l_hg_date,
          l_redeem_lawdate,
          a.l_redeem_liquidate,
          a.l_settle_date,
          a.l_redeal_date,
          a.l_settle_speed,
          c.vc_report_code,
          a.C_ENTRUST_DIRECTION,
          b.vc_entrustdir_name,
          c.c_stock_type,
          b.c_stock_direction,
          a.c_redeal_flag,
          a.l_fund_id,
          d.vc_fund_name,
          h.l_asset_id,
          h.vc_asset_name,
          e.vc_combi_no,
          a.l_basecombi_id,
          e.vc_combi_name,
          a.vc_stockholder_id,
          a.l_operator_no) tt
 where 1 = 1
   --and tt.VC_FUND_CODE in ('3M5016') --基金代码
   --and tt.VC_COMBI_NO in ('') --组合代码
   --and tt.VC_COMBI_NAME like '%%' --组合名称
   --and tt.VC_REPORT_CODE like '%%' --回购代码
   --and tt.VC_ENTRUSTDIR_NAME like '%%' --委托方向
   --and tt.L_REDEEM_LIQUIDATE >= '' --实际购回日期
   --and tt.L_REDEEM_LIQUIDATE <= ''
 --order by tt.L_HG_DATE desc, tt.L_FUND_ID asc