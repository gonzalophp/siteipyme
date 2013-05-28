<div>
    <div class="modal-header">
        <p class="ipymeTitle">Provider</p>
    </div>
    <div class="modal-body">
        <table>
            <tbody>
                <tr>
                    <td>ID:</td><td>{{dialogForm.fields.p_id}}</td>
                </tr>
                <tr>
                    <td>Provider (Alias):</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.fields.p_provider_name"/></td>
                </tr>
                <tr>
                    <td>Provider ID:</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.fields.ie_legal_id"/></td>
                </tr>
                <tr>
                    <td>Invoice Name:</td><td><textarea ng-readonly="dialogForm.readonly" ng-model="dialogForm.fields.ie_invoice_name"></textarea></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="modal-footer">
        <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
    </div>
</div>