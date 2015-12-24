(function() {
    'use strict';

    angular.module('app.auth', [
        'app.core',
        'app.widgets',
        'ngFacebook',
        'app.popover'
    ])
        .config(function($facebookProvider) {
            $facebookProvider.setAppId('910448932375944');
            $facebookProvider.setPermissions('public_profile, email');
        })

        .run(loadInfoBlocks);

    loadInfoBlocks.$inject = ['InfoBlock', '$rootScope'];
    function loadInfoBlocks(InfoBlock, $rootScope) {
        //Load Info Blocks
        InfoBlock.api.loadInfoBlocks();
        $rootScope.getInfoByKey = InfoBlock.api.getInfoByKey;

        //Load Facebook SDK
        (function(d) {
            var js,
                id = 'facebook-jssdk',
                ref = d.getElementsByTagName('script')[0];
            if (d.getElementById(id)) {
                return;
            }
            js = d.createElement('script');
            js.id = id;
            js.async = true;
            js.src = '//connect.facebook.net/en_US/sdk.js';
            ref.parentNode.insertBefore(js, ref);
        }(document));
    }
})();
