<main-menu class="adminmenu" ng-controller="MainMenuController"></main-menu>
<link rel="stylesheet" href="css/list.css"/>
<div ng-switch="adminList" class="container" ng-controller="AdminListController">
    <table ng-switch-when="product">
        <tr>
            <td class="ipymeTitle" colspan="3">{{adminList | firstcapital}}</td>
        </tr>
        <tr >
            <td  rowspan="2" class="ipymeCategory" ng-controller="categorytreeselectcontroller">
                <div id="categorytree"></div>
            </td>
            <td class="ipymeRightPanel">
                <div class="gridStyle"  ng-grid="gridOptions"></div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="ipymeButtonGroup" ng-controller="MenuGroup" >
                    <button ng-repeat="item in menuitems" class="ipymeButton" ng-click="openDialog(item.start_empty, item.form,item.buttons,item.readonly)">{{item.displayName}}</button>&nbsp;
                </div>
            </td>
        </tr>
    </table>
    <table ng-switch-default>
        <tr>
            <td class="ipymeTitle" colspan="3">{{adminList | firstcapital}}</td>
        </tr>
        <tr >
            <td class="ipymeRightPanel">
                <div class="gridStyle"  ng-grid="gridOptions"></div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="ipymeButtonGroup" ng-controller="MenuGroup" >
                    <button ng-repeat="item in menuitems" class="ipymeButton" ng-click="openDialog(item.start_empty, item.form,item.buttons,item.readonly)">{{item.displayName}}</button>&nbsp;
                </div>
            </td>
        </tr>
    </table>
</div>
