<div>
    <div class="modal-header">
        <p class="ipymeTitle">Customer</p>
    </div>
    <div class="modal-body">
        <table>
            <tbody>
                <tr>
                    <td>ID:</td><td>{{dialogForm.fields.c_id}}</td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="modal-footer">
        <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
    </div>
</div>