<div>
    <div class="modal-header">
        <p class="ipymeTitle">Product</p>
    </div>
    <div class="modal-body">
        <table>
            <tr>
                <td>
                    <table>
                        <tbody>
                            <tr>
                                <td>Category:</td><td>{{product.categoryselected.category}}</td>
                            </tr>
                            <tr>
                                <td>ID:</td><td>{{dialogForm.data.fields.p_id}}</td>
                            </tr>
                            <tr>
                                <td>Reference:</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.p_ref"/></td>
                            </tr>
                            <tr>
                                <td>Description:</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.p_description"/></td>
                            </tr>
                            <tr>
                                <td>Long Description:</td><td><textarea ng-readonly="dialogForm.readonly" ng-model="dialogForm.data.fields.p_long_description"></textarea></td>
                            </tr>
                            <tr>
                                <td>Price:</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.p_price"/></td>
                            </tr>
                            <tr>
                                <td>Picture:</td><td><imageupload imagechange="_imagechanged" ng-model="dialogForm.data.fields.p_image_path"></imageupload></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
                <td class="attributevaluelistinput">
                    <div >
                        <p class="ipymeTitle">Tags Values</p>
                        <table>
                            <tbody>
                                <tr ng-repeat="productattribute in dialogForm.data.category_attribute">
                                    <td>{{productattribute.pca_attribute}}</td>
                                    <td><input type="text" ng-model="productattribute.attribute_value_selected" typeahead="attributevalue for attributevalue in productattribute.attribute_values  | filter:$viewValue "></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="modal-footer">
        <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
    </div>
</div>