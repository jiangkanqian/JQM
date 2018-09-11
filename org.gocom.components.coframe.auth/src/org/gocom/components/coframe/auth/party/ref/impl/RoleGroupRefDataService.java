/*
 * Copyright 2013 Primeton Technologies Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.gocom.components.coframe.auth.party.ref.impl;

import java.util.ArrayList;
import java.util.List;

import org.gocom.components.coframe.auth.party.manager.DefaultRoleManager;
import org.gocom.components.coframe.auth.queryentity.QueryGroupByRole;
import org.gocom.components.coframe.rights.dataset.CapRole;
import org.gocom.components.coframe.tools.IConstants;

import com.eos.spring.BeanFactory;
import com.primeton.cap.party.IPartyTypeRefDataService;
import com.primeton.cap.party.Party;

/**
 * 角色工作组关系描述(角色为父，工作组为子)
 *
 * @author gouyl (mailto:gouyl@primeton.com)
 */
public class RoleGroupRefDataService implements IPartyTypeRefDataService {

	private DefaultRoleManager roleBean = null;

	public RoleGroupRefDataService() {
		BeanFactory beanFactory = BeanFactory.newInstance();
		roleBean = beanFactory.getBean(DefaultRoleManager.SPRING_BEAN_NAME);
	}

	/**
	 * 根据角色获取工作组列表
	 * @param parentPartyID 角色ID
	 * @param tenantID 租户ID
	 * @return 工作组列表
	 */
	public List<Party> getChildrenPartyList(String parentPartyID, String tenantID) {
		List<Party> returnList = new ArrayList<Party>();
		QueryGroupByRole[] queryGroupByRoles = roleBean.queryGroupsByRoleId(parentPartyID, tenantID);
		if (queryGroupByRoles != null) {
			for (QueryGroupByRole queryGroupByRole : queryGroupByRoles) {
				returnList.add(new Party(IConstants.GROUP_PARTY_TYPE_ID, String.valueOf(queryGroupByRole.getGroupid()), 
						queryGroupByRole.getGroupname(), queryGroupByRole.getGroupname(), queryGroupByRole.getTenantId()));
			}
		}
		return returnList;
	}

	/**
	 * 根据工作组获取角色列表
	 * @param childPartyID 工作组ID
	 * @param tenantID 租户ID
	 * @return 角色列表
	 */
	public List<Party> getParentPartyList(String childPartyID, String tenantID) {
		List<Party> returnList = new ArrayList<Party>();
		CapRole[] roleArray = roleBean.getCapRoleListByAuthParty(IConstants.GROUP_PARTY_TYPE_ID, childPartyID, tenantID);
		if (roleArray != null) {
			for (CapRole role : roleArray) {
				returnList.add(new Party(IConstants.ROLE_PARTY_TYPE_ID, String.valueOf(role.getRoleId()), role.getRoleCode(), role.getRoleName(), role
						.getTenantId()));
			}
		}
		return returnList;
	}
}
