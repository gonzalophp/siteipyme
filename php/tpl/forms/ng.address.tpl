<div class="modal-header">
    <p class="ipymeTitle">Address</p>
</div>
<div class="modal-body">
    <table>
        <tbody>
            <input type="hidden" ng-model="dialogForm.data.fields.address_detail_ad_id" />
            <tr>
                <td>Address Description</td>
                <td><input type="text" ng-model="dialogForm.data.fields.address_detail_ad_description" /></td>
                <td>
                </td>
            </tr>
            <tr>
                <td>Address Line 1</td>
                <td><input type="text" ng-model="dialogForm.data.fields.address_detail_ad_line1" /></td>
                <td></td>
            </tr>
            <tr>
                <td>Address Line 2</td>
                <td><input type="text" ng-model="dialogForm.data.fields.address_detail_ad_line2" /></td>
                <td></td>
            </tr>
            <tr>
                <td>Post Code</td>
                <td><input type="text" ng-model="dialogForm.data.fields.address_detail_ad_town" /></td>
                <td></td>
            </tr>
            <tr>
                <td>Town</td>
                <td><input type="text" ng-model="dialogForm.data.fields.address_detail_ad_post_code" /></td>
                <td></td>
            </tr>
            <tr>
                <td>Country</td>
                <td>
                    <select ui-select2='dialogForm.data.countries.selectcountryoptions' ng-model="dialogForm.data.fields.address_detail_ad_country.country_c_code" >
                        <option value=""></option>
                        <option ng-repeat="country in dialogForm.data.countries.available" value="{{country.c_code}}">{{country.c_name}}</option>
                    </select>
                </td>
                <td></td>
            </tr>
        </tbody>
    </table>
</div>
<div class="modal-footer">
    <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
</div>
