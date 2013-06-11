<div class="modal-header">
    <p class="ipymeTitle">Account</p>
</div>
<div class="modal-body">
    <table>
        <tbody>
            <tr>
                <td>Title</td>
                <td>
                    <select ng-model="dialogForm.data.fields.people_p_title" ng-options="title for title in dialogForm.data.titles"></select>
                </td>
            </tr>
            <tr>
                <td>First Name</td>
                <td>
                    <input type="text" ng-model="dialogForm.data.fields.people_p_name">
                </td>
            </tr>
            <tr>
                <td>surname</td>
                <td>
                    <input type="text" ng-model="dialogForm.data.fields.people_p_surname">
                </td>
            </tr>
            <tr>
                <td>Home phone</td>
                <td>
                    <input type="text" ng-model="dialogForm.data.fields.people_p_phone">
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="modal-footer">
    <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
</div>
