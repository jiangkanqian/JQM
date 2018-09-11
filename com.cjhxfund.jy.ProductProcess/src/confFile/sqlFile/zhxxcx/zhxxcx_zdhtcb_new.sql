----综合信息查询SQL-自动化头寸表查询
select distinct t1.l_fund_id, --基金ID
       t1.vc_fund_code, --基金代码
       t1.vc_fund_name, --基金名称
       t1.xh, --序号
       t1.bz, --备注
       t1.d_col, --D 期初余额
       t1.f_col, --F 银行间正回购，首次结算日为当日，金额为正
       t1.g_col, --G 银行间逆回购，首次结算日为当日，金额为负  
       t1.h_col, --H T日成交的T+0银行间买券,结算日为当日，金额为负
       t1.i_col, --I T日成交的T+0银行间卖券,结算日为当日，金额为正
       t1.j_col, --J 银行间正回购到期，到期结算日为当日，金额为负
       t1.k_col, --K 银行间逆回购到期，到期结算日为当日，金额为正
       t1.l_col, --L T-1日成交的T+1交收的银行间买券，结算日为当日，金额为负
       t1.m_col, --M T-1日成交的T+1交收的银行间卖券，结算日为当日，金额为正
       t1.n_col, --N 银行间分销，金额为负
       t1.o_col, --O 交易所分销，金额为负
       t1.p_col, --P 基金申购，金额为负
       t1.q_col, --Q 基金赎回，赎回到账日为当日，金额为正
       t1.r_col, --R 红利到账，金额为正
       t1.s_col, --S 期货户入金,期货保证金调整的期货保证金增加，金额为负
       t1.t_col, --T 期货户出金,期货保证金调整的期货保证金减少，金额为正
       t1.u_col, --U 同业存款，即定期存款，金额为负
       t1.v_col, --V 同业存款到期，即定期存款到期，到期日为当日，金额为正
       t1.w_col, --W 当日债券兑付/付息/部分兑付/部分提前兑付(沪深),金额为正
       t1.x_col, --X 当日债券兑付/付息/部分兑付/部分提前兑付(非沪深),金额为正
       t1.y_col, --Y 追加，即当日资金管理手工增加资金，金额为正
       t1.z_col, --Z 提取，即当日资金管理手工减少资金，金额为负
       t1.aa_col, --AA 当日TA申购，金额为正
       t1.ab_col, --AB TA赎回，赎回款到账日为当日，金额为负
       t1.ac_col, --AC 网下申购，金额为负
       t1.ad_col, --AD 网下申购退款，金额为正
       t1.al_col, --AL 费用支付，金额为负
       t1.am_col, --AM 新股配售交收，金额为负
       t1.ae_col, --AE RTGS非担保卖券,清算速度T+0，金额为正
       t1.af_col, --AF RTGS非担保买券,清算速度T+0，金额为负
       t1.ai_col, --AI 手工调整1
       t1.aj_col, --AJ 手工调整2
       t1.an_col, --AN 资金冻结，金额为正
       t1.ao_col, --AO 资金冻结取消,金额为正
       t1.ap_col, --AP 资金增加,金额为正
       t1.ak_col, --AK 余额
       t2.tzje, --手工调整金额
       t2.bz as sgtz_bz, --手工调整备注
       t1.am1_col, --AM1 机器猫当日下单的追加,金额为正
       t1.am2_col --AM2 通过机器猫下单在O32控头寸的提取，金额为负
  from o32_cj.to32_js_rs t1
  left join o32_cj.TO32_JS_SGTZ t2
    on t1.l_fund_id = t2.l_fund_id
   and t1.xh = t2.xh
   and substr(t1.rq, 1, 8) = to_char(t2.tzsj, 'yyyyMMdd')
 where 1 = 1
   --and t1.vc_fund_code in ('001199', '3M2001', '3M5028')
 --order by t1.l_fund_id, t1.xh;
