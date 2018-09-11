package com.cjhxfund.jy.DataProcess;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PbExcutor extends Excutor{
	
	private List<PositionBasic> list;
	
	public PbExcutor(){
		this.list = new ArrayList<PositionBasic>();
	}
	
	public PbExcutor(List<PositionBasic> list){
		this.list = list;
	}
	
	public List<PositionBasic> resProcess(ResultSet set){
		
		//遍历结果集
        try {
			while(set.next()){  			    
				PositionBasic pb = new PositionBasic();
				
				pb.setlFundId(set.getLong("l_fund_id"));
				pb.setlDate(set.getString("l_date"));
				pb.setVcFundCode(set.getString("vc_fund_code"));
				pb.setVcFundName(set.getString("vc_fund_name"));
				pb.setVcCombiNo(set.getString("vc_combi_no"));
				pb.setVcCombiName(set.getString("vc_combi_name"));
				pb.setVcInterCode(set.getString("vc_inter_code"));
				pb.setVcReportCode(set.getString("vc_report_code"));
				pb.setVcStockName(set.getString("vc_stock_name"));
				pb.setcStockType(set.getString("c_stock_type"));
				pb.setlUsableAmount(set.getLong("l_usable_amount"));
				pb.setlCurrentAmount(set.getLong("l_current_amount"));
				pb.setcPositionFlag(set.getString("c_position_flag"));
				pb.setcMarketNo(set.getString("c_Market_No"));
				pb.setcTrustee(set.getString("c_trustee"));
				pb.setVcInterCodeWind2(set.getString("vc_inter_code_wind2"));
				pb.setIsBuyBack(set.getString("is_buy_back"));
				pb.setIsSellBack(set.getString("is_sell_back"));
				
				//System.out.println(pb.toString());
				list.add(pb);
			}
			
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		} 
        
        return list;
        
	}
	
	
	
}
