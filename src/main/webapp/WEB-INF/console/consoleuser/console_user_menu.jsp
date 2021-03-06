<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
String rootPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>授权管理</title>


<%
	String classJson = (String)request.getAttribute("classJson");
%>
<SCRIPT type="text/javascript">
		function jump(_sUrl){
			$('body').layout('panel','center').panel('refresh',_sUrl);
		}
</SCRIPT>		
	<SCRIPT type="text/javascript">
		var zNodes = <%=classJson%>;
		var setting = {
			view: {
				addHoverDom: addHoverDom,	
				removeHoverDom: removeHoverDom,
				selectedMulti: false
			},
			edit: {
				enable: true,
				editNameSelectAll: true
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
				onClick: onClick
			}
		};
		
		var log, className = "dark";
		function beforeDrag(treeId, treeNodes) {
			return false;
		}
		
		function beforeEditName(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.selectNode(treeNode);
			return confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？");
		}
		function beforeRemove(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.selectNode(treeNode);
			return confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
		}
		function onRemove(e, treeId, treeNode) {
			showLog("[ "+getTime()+" onRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
		}
		function beforeRename(treeId, treeNode, newName, isCancel) {
			className = (className === "dark" ? "":"dark");
			showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
			if (newName.length == 0) {
				alert("节点名称不能为空.");
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				setTimeout(function(){zTree.editName(treeNode)}, 10);
				return false;
			}
			return true;
		}
		function onRename(e, treeId, treeNode, isCancel) {
			showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" onRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
		}
		function showRemoveBtn(treeId, treeNode) {
			return !treeNode.isFirstNode;
		}
		function showRenameBtn(treeId, treeNode) {
			return !treeNode.isLastNode;
		}
		function showLog(str) {
			if (!log) log = $("#log");
			log.append("<li class='"+className+"'>"+str+"</li>");
			if(log.children("li").length > 8) {
				log.get(0).removeChild(log.children("li")[0]);
			}
		}
		function getTime() {
			var now= new Date(),
			h=now.getHours(),
			m=now.getMinutes(),
			s=now.getSeconds(),
			ms=now.getMilliseconds();
			return (h+":"+m+":"+s+ " " +ms);
		}

		var newCount = 1;
		function addHoverDom(treeId, treeNode) {
			var sObj = $("#" + treeNode.tId + "_span");
			if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
				+ "' title='add node' onfocus='this.blur();'></span>";
			sObj.after(addStr);
			var btn = $("#addBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, name:"new node" + (newCount++)});
				return false;
			});
		};
		
		function removeHoverDom(treeId, treeNode) {
			$("#addBtn_"+treeNode.tId).unbind().remove();
		};
		function selectAll() {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
		}
		function onClick(e, treeId, treeNode) {
			
			//点击获取节点的id
			//alert(treeNode.id + "节点的id");
			//点击获取父节点的pId
			///alert(treeNode.pId + "父节点pId");
			var _cUrl="<%=rootPath%>superadmin/ConsoleMenu/getAllConsoleMenus?pId="+treeNode.pId+"&id="+treeNode.id+"&_type=classify";
			//加载该分类下的子分类
			jump(_cUrl);			
		}	
		function getSelectedNodes() {
			alert("111");
			var treeObj = $.fn.zTree.getZTreeObj("tree");
			var nodes = treeObj.getSelectedNodes();
			alert(nodes);
		}
		
		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		});
		//-->
	</SCRIPT>	
<style type="text/css">
.ztree li span.button.add {margin-left:10px; margin-right: -1px; background-position:-144px 0; vertical-align:top; vertical-align:middle}
</style>
</head>


<div id="menu" class="easyui-accordion" fit="true" border="false">
	<c:forEach items="${sessionScope.allMenu}" var="allM">
		<c:if test="${allM.key=='console'}">
			<c:forEach items="${allM.value}" var="second" varStatus="iz">
				<c:if test="${second.key.ismenu!='3' }">
					<div title="${second.key.menuName }" style="padding:0px;" selected="true" class="arrowsidemenu">
						<ul class="menucontents">
							<c:forEach items="${second.value}" var="third">
								<li><a href="javascript:void(0)" onclick="jump('<%=rootPath%>${third.menuHref }')">${third.menuName }</a></li>
							</c:forEach>
						</ul>
					</div>
				</c:if>
				<c:if test="${second.key.ismenu=='3' }">
					<div title="菜单管理" >
						<div class="content_wrap" >
							<div class="zTreeDemoBackground left" style="width: 100%;height: 100%">
								<div id="treeDemo" class="ztree" style="background-color: white;height: 100%;border: none;" ></div>
							</div>
						</div>
					</div>
				</c:if>
			</c:forEach>
		</c:if>
	</c:forEach>
	
	
</div>
</body>
</html>
