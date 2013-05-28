<link rel="stylesheet" href="css/signin.css"/>
<div class="ipymedialog">
    <div class="ipymeSignin" ng-controller="CtrlSignUpConfirmation">
        <p class="ipymeTitle">Sign Up Confirmation</p>
        <div ng-switch on="signup_confirmation">
            <div ng-switch-when="0">
                <p class="ipymeErrorMessage" style="text-align: left;border:solid;height:5em;">Sign Up registration fail.</p>
            </div>
            <div ng-switch-when="1">
                <p class="ipymeMessage" style="text-align: left;border:solid;height:5em;">Your registration is now complete.</p>
            </div>
        </div>
    </div>
</div>


