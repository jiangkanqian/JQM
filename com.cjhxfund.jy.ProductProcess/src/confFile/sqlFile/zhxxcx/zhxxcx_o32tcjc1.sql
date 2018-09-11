select t0.L_FUND_ID, --基金序号
       t0.VC_FUNDCODE, --基金代码
       t0.VC_FUNDNAME, --基金名称
       t0.L_ASSET_ID, --资产单元序号
       t0.VC_ASSETNAME, --资产单元名称
       t0.JYSTC_SH, --交易所头寸情况(上交所)
       t0.JYSTC_SZ, --交易所头寸情况(深交所)
       t0.T0_BALANCE, --T+0头寸情况 F
       t0.T1_BALANCE, --T+1头寸情况 G
       t0.EN_YHJ_ZQ, --当日T+0交易意向 H
       t0.EN_YHJ_ZQ_T0CJ, --当日T+0前台成交 I
       t0.EN_YHJ_ZQ_T1CJ, --昨日T+1资金流入 J
       t0.EN_YHJ_RQGH, --当日逆回购到期  K
       t0.EN_YHJ_DXDF, --当日债券兑付兑息 L
       t0.EN_YHJ_TQDJ, --次日正回购到期提前冻结 M
       t0.EN_JYS_ZLZY1, --指令占用(上海) O
       t0.EN_JYS_ZLZY2, --指令占用(深圳) O
       t0.EN_JYS_QZMM1, --股票权证买卖(上海) P
       t0.EN_JYS_QZMM2, --股票权证买卖(深圳) P
       t0.EN_JYS_ZQMM1, --债券买卖(上海) Q
       t0.EN_JYS_ZQMM2, --债券买卖(深圳) Q
       t0.EN_JYS_RZHG1, --正回购首期(上海) R
       t0.EN_JYS_RZHG2, --正回购首期(深圳) R
       t0.EN_JYS_RZGH1, --正回购到期(上海) S
       t0.EN_JYS_RZGH2, --正回购到期(深圳) S
       t0.EN_JYS_RQHG1, --逆回购首期(上海) T
       t0.EN_JYS_RQHG2, --逆回购首期(深圳) T
       t0.EN_JYS_RQGH1, --逆回购到期(上海) U
       t0.EN_JYS_RQGH2, --逆回购到期(深圳) U
       t0.EN_JYS_FDBJS1, --非担保交收(上海) V
       t0.EN_JYS_FDBJS2, --非担保交收(深圳) V
       t0.EN_XX_CKZQK, --存款支取款 W
       t0.EN_WJS_JJSH, --基金赎回款 X
       t0.EN_WJS_WXSG, --网下申购退款 Y
       t0.EN_BFJ_TQDJ, --备付金保证金提前冻结 Z
       t0.EN_SH_TQDJ, --赎回分红款提前冻结 AA
       t0.EN_FYTQDJ, --费用提前冻结 AB
       t0.EN_ZJSGDJ, --资金手工冻结 AC
       t0.EN_ZJJD, --资金手工解冻 AD
       t0.EN_ZJTQ, --追加提取 AE
       t0.EN_YJXZ, --一级新债 AF
       t0.EN_XYHG, --协议回购 AG
       t0.T0_POS, --T+0交易头寸 AH
       t0.T0_POS2, --不包含T+1变化的T+0可用 AI
       t0.T1_POS, --T+1交易可用 AJ
       t1.en_balance en_balance1, --手工调整金额(1-追加提取)
       t1.bz bz1, --手工调整备注(1-追加提取)
       t2.en_balance en_balance2, --手工调整金额(2-一级新债)
       t2.bz bz2, --手工调整备注(2-一级新债)
       t3.en_balance en_balance3, --手工调整金额(3-协议回购)
       t3.bz bz3 --手工调整备注(3-协议回购)
  from o32_cj.TO32_POS_CHECK_RS_NEW t0
  left join (select * from o32_cj.TO32_POS_CHECK_SGTZ t where t.tztype = '1') t1
    on t0.l_fund_id = t1.l_fund_id
   and t0.l_asset_id = t1.l_asset_id
   and to_char(t0.rq, 'yyyyMMdd') = to_char(t1.xgrq, 'yyyyMMdd')
  left join (select * from o32_cj.TO32_POS_CHECK_SGTZ t where t.tztype = '2') t2
    on t0.l_fund_id = t2.l_fund_id
   and t0.l_asset_id = t2.l_asset_id
   and to_char(t0.rq, 'yyyyMMdd') = to_char(t2.xgrq, 'yyyyMMdd')
  left join (select * from o32_cj.TO32_POS_CHECK_SGTZ t where t.tztype = '3') t3
    on t0.l_fund_id = t3.l_fund_id
   and t0.l_asset_id = t3.l_asset_id
   and to_char(t0.rq, 'yyyyMMdd') = to_char(t3.xgrq, 'yyyyMMdd')
 where 1 = 1
   --and t0.VC_FUNDCODE in ('001199')
   --and t0.VC_ASSETNAME like '%%'
 --order by t0.VC_FUNDCODE asc;
