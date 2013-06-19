<div class="ipymeshop">
    <shoptopbar></shoptopbar>
    <div class="ipymeshopbody" ng-controller="basketCtrl">
        <div class="basket">
            <basketsummary class="basketsummary" persist="basketpersist" ng-model="model"></basketsummary> 
        </div>
        
        <div class="paymentcheckout"  collapse="model.iscollapsed">
            <fieldset>
                <div>
                    <h4>Invoice Details</h4>
                    <p>
                        <label for="name">Name</label>
                        <input type="text" ng-model="model.customer.name"/>
                    </p>
                    <p>
                        <label for="surname">Surname</label>
                        <input type="text" ng-model="model.customer.surname"/>
                    </p>
                    <p>
                        <label for="company">Company</label>
                        <input type="text" ng-model="model.customer.company"/>
                    </p>
                    <p>
                        <label for="date">Date</label>
                        <input type="text" ui-date="model.dateoptions" ng-model="model.customer.dob" />
                    </p>
                    <p>
                        <label for="address1">Address</label>
                        <input type="text" id="address1" ng-model="model.customer.add1" />
                    </p>
                    <p>
                        <label for="address2">Address (Line 2)</label>
                        <input type="text" id="address2" ng-model="model.customer.add2" />
                    </p>
                    <p>
                        <label for="post_code">Post Code</label>
                        <input type="text" id="postcode" ng-model="model.customer.postcode" />
                    </p>
                    <p>
                        <label for="address2">Town</label>
                        <input type="text" id="address2" ng-model="model.customer.town" />
                    </p>
                    <p>
                        <label for="country">Country</label>
                        <input type="text" id="country" ng-model="model.customer.country" />
                    </p>
                    <p class="text">
                        <label for="phone">Home phone</label>
                        <input type="text" class="text" name="phone" ng-model="model.customer.phone">
                    </p>
                    <h4>Payment Details</h4>
                    <p>
                        <label for="cardname">Name on card</label>
                        <input type="text" id="cardname" ng-model="model.customer.card.name" />
                    </p>
                    <p>
                        <label for="cardnumber">Card number:</label>
                        <input type="text" id="cardnumber" ng-model="model.customer.card.number" />
                    </p>
                    <p>
                        <label for="cardexpire">Expire:</label>
                        <input type="text" id="cardexpire" ng-model="model.customer.card.expire" />
                    </p>
                    <p>
                        <label for="cardexpire">Issue number</label>
                        <input type="text" id="cardexpire" ng-model="model.customer.card.issue" />
                    </p>
                    <p>
                        <button class="shop confirm" ng-click="confirm()">Confirm</button>
                    </p>
                </div>
            </fieldset>
        </div>
    </div>
    <footer>
        <p>2013 - Gonzalo Grado </p>
    </footer>
</div>