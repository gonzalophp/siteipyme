<link rel="stylesheet" href="css/shop.css"/>
<link rel="stylesheet" href="css/flags/flags.css"/>
<div class="ipymeshop">
    <shoptopbar></shoptopbar>
    
    <script type="text/ng-template" id="paneaccount">
        <p>
            <label for="name">Title</label>
            <select>
                <option>{{model.user_details.people[0].people_p_title}}</option>
            </select>
        </p>
        <p class="text">
            <label for="phone">First Name</label>
            <input type="text" class="text" name="phone" ng-model="model.user_details.people[0].people_p_name">
        </p>
        <p class="text">
            <label for="surname">surname</label>
            <input type="text" class="text" name="phone" ng-model="model.user_details.people[0].people_p_surname">
        </p>
        <p>
            <label for="surname">Email</label>
            <input type="text" ng-model="model.user_details.user_u_email"/>
        </p>
        <p class="text">
            <label for="phone">Home phone</label>
            <input type="text" class="text" name="phone" ng-model="model.user_details.people[0].people_p_phone">
        </p>
        
    </script>
    <script type="text/ng-template" id="paneaddress">
        <table>
            <tbody>
                <tr>
                    <td></td>
                    <td colspan="2">
                        <button style="margin-bottom:1em" class="shop" ng-click="addAddress()">New Address</button>
                    </td>
                </tr>
                <tr>
                    <td>Address Description</td>
                    <td>
                        <select ng-model="model.user_details.address_selected" ng-options="address.address_detail_ad_description for address in model.user_details.addresses"></select>
                    </td>
                    <td><button class="shop" ng-click="editAddress()">Edit</button></td>
                </tr>
                <tr>
                    <td>Address Line 1</td>
                    <td><input type="text" id="address1" ng-model="model.user_details.address_selected.address_detail_ad_line1" /></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Address Line 2</td>
                    <td><input type="text" id="address2" ng-model="model.user_details.address_selected.address_detail_ad_line2" /></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Post Code</td>
                    <td><input type="text" id="address2" ng-model="model.user_details.address_selected.address_detail_ad_town" /></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Town</td>
                    <td><input type="text" id="postcode" ng-model="model.user_details.address_selected.address_detail_ad_post_code" /></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Country</td>
                    <td>
                        <select ui-select2='model.countries.selectcountryoptions' ng-model="model.user_details.address_selected.country_c_code" >
                            <option value=""></option>
                            <option ng-repeat="country in model.countries.available" value="{{country.c_code}}">{{country.c_name}}</option>
                        </select>
                    </td>
                    <td></td>
                </tr>
            </tbody>
        </table>
    </script>
    
    <script type="text/ng-template" id="panepayments">
        <p>
            <label for="address1">Description</label>
            <select>
                <option value="">{{model.user_details.card[0].card_c_description}}</option>
            </select>
            
        </p>
        <p>
            <label for="cardname">Name on card</label>
            <input type="text" id="cardname" ng-model="model.user_details.card[0].card_c_name" />
        </p>
        <p>
            <label for="cardnumber">Card number:</label>
            <input type="text" id="cardnumber" ng-model="model.user_details.card[0].card_c_card_number" />
        </p>
        <p>
            <label for="cardexpire">Expire:</label>
            <input type="text" id="cardexpire" ng-model="model.user_details.card[0].card_c_expire_date" />
        </p>
        <p>
            <label for="cardexpire">Issue number</label>
            <input type="text" id="cardexpire" ng-model="model.user_details.card[0].card_c_issue_numer" />
        </p>
    </script>
    
    <script type="text/ng-template" id="paneorders">
        <div class="gridStyle"  ng-grid="model.orders.ordersGridOptions"></div>
    </script>
    
    <div class="ipymeshopbody" ng-controller="UserController">
        
        <tabs>
            <pane ng-repeat="pane in model.panes" heading="{{pane.title}}" active="pane.active">
                <div ng-include="pane.template"></div>
            </pane>
        </tabs>
        <p>
            <button class="shop confirm" ng-click="dale()">Save</button>
        </p>
    </div>
    <footer>
        <p>2013 - Gonzalo Grado </p>
    </footer>
</div>