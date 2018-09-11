/*
 * Copyright 2013 Primeton.
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
package org.gocom.components.coframe.entityauth;

import java.util.ArrayList;
import java.util.List;

import org.gocom.components.coframe.entityauth.helper.RuleHelper;
import org.gocom.components.coframe.entityauth.pojo.ConValue;
import org.gocom.components.coframe.entityauth.pojo.RightValue;
import org.gocom.components.coframe.tools.CoframeDASDaoSupport;

import com.primeton.cap.impl.dataset.service.DatasetSupportBase;
import com.primeton.cap.spi.dataset.model.ERDiagram;
import com.primeton.cap.spi.dataset.model.ERDiagramRepository;
import com.primeton.cap.spi.dataset.model.Entity;
import com.primeton.cap.spi.dataset.service.EntityInfo;
import com.primeton.cap.spi.dataset.service.IPropertyInfoFilter;
import com.primeton.cap.spi.dataset.service.PropertyInfo;

/**
 * 实体服务类
 * 
 * @author lijt (mailto:lijt@primeton.com)
 */
public class EntityService extends CoframeDASDaoSupport implements IEntityService {
	
	private DatasetSupportBase datasetSupport = new DatasetSupportBase();

	/*
	 * （non-Javadoc）
	 * 
	 * @see org.gocom.components.coframe.entityauth.IEntityService#queryEntities()
	 */
	public EntityInfo[] queryEntities() {
		List<EntityInfo> entityInfoList = new ArrayList<EntityInfo>();
		List<ERDiagram> diagrams = ERDiagramRepository.INSTANCE.listAllERDiagrams();
		for (ERDiagram diagram : diagrams) {
			for (Entity entity : diagram.listNotREntities()) {
				if (!Entity.ENTITY_TYPE_NENTITY.equals(entity.getEntityType())) {
					entityInfoList.add(new EntityInfo(entity));
				}
			}
		}
		
		List<EntityInfo> finalEntityInfoList = new ArrayList<EntityInfo>();
		for (int i = 0; i < entityInfoList.size(); i++) {
			if(RuleHelper.isEntityFilter(entityInfoList.get(i).getQName())) {
				finalEntityInfoList.add(entityInfoList.get(i));
			}
		}
		return finalEntityInfoList.toArray(new EntityInfo[finalEntityInfoList.size()]);
	}

	/*
	 * （non-Javadoc）
	 * 
	 * @see org.gocom.components.coframe.entityauth.IEntityService#queryPropertyInfos(java.lang.String,
	 *      java.lang.String)
	 */
	public PropertyInfo[] queryPropertyInfos(String namespace, String entityName) {

		if (namespace == null || "".equals(namespace)) {
			return null;
		}

		List<PropertyInfo> sPropertyInfoList = listSimpleProperties(namespace, entityName);
		
		List<PropertyInfo> filterPropertyInfoList = new ArrayList<PropertyInfo>();
		if(sPropertyInfoList != null) {
			for(PropertyInfo propertyInfo : sPropertyInfoList) {
				if("BlobByteArray".equals(propertyInfo.getTypeName()) || "ClobString".equals(propertyInfo.getTypeName())
						 || "ClobFile".equals(propertyInfo.getTypeName()) || "BlobFile".equals(propertyInfo.getTypeName())
						 || "Byte".equals(propertyInfo.getTypeName())) {
					filterPropertyInfoList.add(propertyInfo);
				}
			}
			sPropertyInfoList.removeAll(filterPropertyInfoList);
		}
		
		List<PropertyInfo> rPropertyInfoList = listPropertiesFor1(namespace, entityName);

		int slength = 0;
		if (sPropertyInfoList != null && sPropertyInfoList.size() != 0) {
			slength = sPropertyInfoList.size();
		}
		int rlength = 0;
		if (rPropertyInfoList != null && rPropertyInfoList.size() != 0) {
			rlength = rPropertyInfoList.size();
		}

		if (slength == 0 && rlength == 0) {
			return null;
		} else {
			List<PropertyInfo> propertyInfoList = new ArrayList<PropertyInfo>();
			propertyInfoList.addAll(sPropertyInfoList);
			propertyInfoList.addAll(rPropertyInfoList);
			
			

			PropertyInfo[] propertyInfos = new PropertyInfo[slength + rlength];
			for (int i = 0; i < slength + rlength; i++) {
				propertyInfos[i] = propertyInfoList.get(i);
			}
			return propertyInfos;
		}
	}
	
	/**
	 * 列出指定实体的基本属性.<br>
	 * 即不包含关联属性.<br>
	 * 
	 * @param namespace 名称空间
	 * @param entityName 实体短名称
	 * @return 属性信息列表
	 */
	private List<PropertyInfo> listSimpleProperties(String namespace, String entityName) {
		List<PropertyInfo> infos = datasetSupport.listProperties(namespace, entityName, new IPropertyInfoFilter() {
			public boolean accept(PropertyInfo info) {
				return info.getHierarchialLevel() == 0 && !info.isAssocationProperty();
			}
		});
		return infos;
	}	
	
	/**
	 * 列出指定实体的关联的1端的实体的基本属性.<br>
	 * 
	 * @param namespace 名称空间
	 * @param entityName 实体短名称
	 * @param filter 属性信息过滤器
	 * @return 属性信息列表
	 */
	private List<PropertyInfo> listPropertiesFor1(String namespace, String entityName) {
		List<PropertyInfo> infos = datasetSupport.listProperties(namespace, entityName, new IPropertyInfoFilter() {
			public boolean accept(PropertyInfo info) {
				if (info.getHierarchialLevel() != 1 || info.isAssocationProperty()) {
					return false;
				}
				if (info.getAssociationType() != PropertyInfo.ASSOCIATIONTYPE_U11 && info.getAssociationType() != PropertyInfo.ASSOCIATIONTYPE_UN1) {
					return false;
				}
				return true;
			}
		});
		return infos;
	}

	/*
	 * （non-Javadoc）
	 * 
	 * @see org.gocom.components.coframe.entityauth.IEntityService#queryPropertyInfo(java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public PropertyInfo queryPropertyInfo(String namespace, String entityName,
			String propertyName) {

		if (namespace == null || "".equals(namespace)) {
			return null;
		}

		List<PropertyInfo> sPropertyInfoList = listSimpleProperties(namespace, entityName);
		List<PropertyInfo> rPropertyInfoList = listPropertiesFor1(namespace, entityName);

		int slength = 0;
		if (sPropertyInfoList != null && sPropertyInfoList.size() != 0) {
			slength = sPropertyInfoList.size();
		}
		int rlength = 0;
		if (rPropertyInfoList != null && rPropertyInfoList.size() != 0) {
			rlength = rPropertyInfoList.size();
		}

		if (slength == 0 && rlength == 0) {
			return null;
		} else {
			List<PropertyInfo> propertyInfoList = new ArrayList<PropertyInfo>();
			propertyInfoList.addAll(sPropertyInfoList);
			propertyInfoList.addAll(rPropertyInfoList);

			for (PropertyInfo propertyInfo : propertyInfoList) {
				if (propertyName.equals(propertyInfo.getHierarchialName())) {
					return propertyInfo;
				}
			}
		}
		return null;
	}

	/*
	 * （non-Javadoc）
	 * 
	 * @see org.gocom.components.coframe.entityauth.IEntityService#getConValuesByCondition(java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public List<ConValue> getConValuesByCondition(String namespace,
			String entityName, String propertyName) {

		if (propertyName == null || "".equals("propertyName")) {
			return ValuePoolService.getConValues(null);
		}

		PropertyInfo propertyInfo = queryPropertyInfo(namespace, entityName,
				propertyName);
		if (propertyInfo == null) {
			return ValuePoolService.getConValues(null);
		} else {
			String type = propertyInfo.getTypeName();
			if ("Int".equals(type) || "Short".equals(type)
					|| "Long".equals(type) || "Float".equals(type)
					|| "Double".equals(type) || "BigInteger".equals(type)
					|| "Decimal".equals(type)) {
				return ValuePoolService.getConValues("Data");
			} else if ("String".equals(type) || "ClobString".equals(type)) {
				return ValuePoolService.getConValues("String");
			} else if ("TimeStamp".equals(type) || "Time".equals(type)
					|| "Date".equals(type)) {
				return ValuePoolService.getConValues("Date");
			} else {
				// BlobByteArray ClobFile BlobFile Byte
				return ValuePoolService.getConValues(null);
			}
		}
	}
	
	/* （non-Javadoc）
	 * 
	 * @see org.gocom.components.coframe.entityauth.IEntityService#getRightValuesByCondition(java.lang.String, java.lang.String, java.lang.String)
	 */
	public List<RightValue> getRightValuesByCondition(String namespace, String entityName, String propertyName) {

		if (propertyName == null || "".equals("propertyName")) {
			return ValuePoolService.getRightValues(null);
		}

		PropertyInfo propertyInfo = queryPropertyInfo(namespace, entityName,
				propertyName);
		if (propertyInfo == null) {
			return ValuePoolService.getRightValues(null);
		} else {
			String type = propertyInfo.getTypeName();
			if ("Int".equals(type) || "Short".equals(type)
					|| "Long".equals(type) || "Float".equals(type)
					|| "Double".equals(type) || "BigInteger".equals(type)
					|| "Decimal".equals(type)) {
				return ValuePoolService.getRightValues("Data");
			} else if ("String".equals(type) || "ClobString".equals(type)) {
				return ValuePoolService.getRightValues("String");
			} else if ("TimeStamp".equals(type) || "Time".equals(type)
					|| "Date".equals(type)) {
				return ValuePoolService.getRightValues("Date");
			} else {
				// BlobByteArray ClobFile BlobFile Byte
				return ValuePoolService.getRightValues(null);
			}
		}
	}

}
