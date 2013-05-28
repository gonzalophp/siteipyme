<div>
    <ul>
        <li class="{{getLiClass(menuitem)}}" ng-repeat="menuitem in menutree" ng-include="'tpl/ng.sub_menu.tpl'"/>
    </ul>
</div>