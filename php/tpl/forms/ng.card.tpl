<div class="modal-header">
    <p class="ipymeTitle">Card</p>
</div>
<div class="modal-body">
    <table>
        <tbody>
            <tr>
                <td>Card Description</td>
                <td><input type="text" ng-model="dialogForm.data.fields.card_c_description" /></td>
            </tr>
            <tr>
                <td>Vendor</td>
                <td>
                    <select ng-model="dialogForm.data.fields.card_vendor_cv_name" ng-options="card_vendor.cv_name for card_vendor in dialogForm.data.card_vendors.available"></select>
                </td>
                <td>{{dialogForm.data.fields.card_vendor_cv_name}}</td>
            </tr>
            <tr>
                <td>Name on card</td>
                <td><input type="text" ng-model="dialogForm.data.fields.card_c_name" /></td>
            </tr>
            <tr>
                <td>Card number</td>
                <td><input type="text" ng-model="dialogForm.data.fields.card_c_card_number" /></td>
            </tr>
            <tr>
                <td>Expire:</td>
                <td><input type="text" ng-model="dialogForm.data.fields.card_c_expire_date" /></td>
            </tr>
            <tr>
                <td>Issue number</td>
                <td><input type="text" ng-model="dialogForm.data.fields.card_c_issue_numer" /></td>
            </tr>
        </tbody>
    </table>
</div>
<div class="modal-footer">
    <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
</div>
