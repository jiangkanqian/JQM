select t1.l_date,
       t1.vc_settlementorderid,
       t1.vc_tradeid,
       t1.vc_buyerholderaccount,
       t1.vc_bholdershortname,
       t1.vc_bagencyholderaccount,
       t1.vc_bagencyholdershortname,
       t1.vc_boperholderaccount,
       t1.vc_sellerholderaccount,
       t1.vc_sholdershortname,
       t1.vc_sagencyholderaccount,
       t1.vc_sagencyholdershortname,
       t1.vc_soperholderaccount,
       t1.vc_productcode,
       t1.vc_productname,
       decode(t1.vc_tradetype,
       '4','现券买卖',
       '5','债券远期',
       '8','债券借贷',
       '9','质押式回购',
       '10','买断式回购',
       '91','非交易质押') as vc_tradetype,
       t1.vc_currency,
       decode(t1.l_settlementtype,
       '0','DVP 券款对付',
       '11','NDVP 净额券款对付')as l_settlementtype,
       decode(t1.c_fullordertype,
       '0','首期',
       '1','到期',
       '2','逾期返售',
       '3','现金交割')as c_fullordertype,
       decode(t1.c_participatetype,
       '1','自营清算',
       '2','委托代理清算')as c_participatetype,
       t1.en_settlementamount,
       t1.en_facevalue,
       decode(t1.c_grossorderstatus,
       '0','待生效',
       '1','应履行',
       '2','交割中',
       '4','修改中',
       '8','成功',
       '9','终止',
       'A','失败',
       'D','作废')as c_grossorderstatus,
       decode(t1.c_fundsettstatus,
       '1','应履行',
       '2','等款',
       '3','款足',
       '4','交割中',
       '5','截止中',
       '8','成功',
       '9','终止',
       'A','失败')as c_fundsettstatus,
       decode(t1.c_productstatus,
       '1','应履行',
       '2','等券',
       '3','券足',
       '4','交割中',
       '8','成功',
       '9','终止',
       'A','失败')as c_productstatus,
       t1.l_createdate,
       t1.l_createtime,
       t1.l_orderstatusupdatetime,
       t1.l_financegraceperiod,
       t1.l_productgraceperiod,
       t1.l_settlementdate,
       decode(t1.vc_boperorderstatus,
       '0','未生效',
       '8','已生效',
       '9','已修改',
       'A','已删除',
       'D','作废')as vc_boperorderstatus,
       decode(t1.vc_soperorderstatus,
       '0','未生效',
       '8','已生效',
       '9','已修改',
       'A','已删除',
       'D','作废')as vc_soperorderstatus,
       t1.vc_payconfirmopername,
       t1.vc_auditopername,
       t1.vc_cancelopername,
       t1.l_canceltime,
       t1.vc_cancelconfirmopername,
       t1.l_cancelconfirmtime,
       t1.c_cancelresult,
       t1.vc_srctradeid,
       decode(t1.c_stocksettle_flag,
       '0','无需交收',
       '1','未处理',
       '2','已修改',
       '3','已交收未复核',
       '4','已交收已复核')as c_stocksettle_flag,
       decode(t1.c_cashsettle_flag,
       '0','无需交收',
       '1','未处理',
       '2','已修改',
       '3','已交收未复核',
       '4','已交收已复核')as c_cashsettle_flag,
       t1.vc_settle_errmsg,
       1 c_from
  from trade.tsqsfulljsinst t1
 where t1.l_org_id = 0
   and t1.l_dept_id = 0