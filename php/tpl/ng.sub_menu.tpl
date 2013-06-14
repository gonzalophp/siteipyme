<div class="{{menuitem.icon}}"></div>
<a menuclick="closemenu" href="{{menuitem.url}}"><span>{{menuitem.label}}</span></a>
<ul ng-show="menuitem.nodes.length>0">
    <li class="{{getLiClass(menuitem)}}" ng-repeat="menuitem in menuitem.nodes" ng-include="'tpl/ng.sub_menu.tpl'"></li>
</ul> 