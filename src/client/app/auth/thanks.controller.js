(function () {
    'use strict';

    angular
        .module('app.auth')
        .controller('ThanksController', ThanksController);

    ThanksController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', 'PreloaderModel', '$rootScope', '$timeout'
    ];
    /* @ngInject */
    function ThanksController(
        $state, logger, requestservice, $stateParams,
        $q, UserModel, PreloaderModel, $rootScope, $timeout
    ) {
        var vm = this;

        vm.menu = {

        };

        vm.model = {
            user: UserModel,
            images: [
                {picture: $rootScope.willGoMobile() ? '../images/site/mobile_thanks.jpg' : '../../images/site/thanks.jpg'},
                {picture: $rootScope.willGoMobile() ? '../images/site/mobile_thanks_bad_zip.jpg' : '../../images/site/thanks_bad_zip.jpg'}
            ]
        };

        activate();

        function activate() {
            PreloaderModel.api.preloadImages(vm.model.images, 'picture', function() {
                $timeout(function() {
                    $rootScope.$broadcast('show-mt-content');
                }, 100);
            });
        }
    }
})();
