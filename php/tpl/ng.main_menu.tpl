<div>
    <ul>
        <li ng-class="{submenu: menuitem.nodes.length>0}" class="{{menuitem.type}}" ng-repeat="menuitem in menutree" ng-include="'tpl/ng.sub_menu.tpl'"/>
    </ul>
</div>