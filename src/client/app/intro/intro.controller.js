(function () {
    'use strict';

    angular
        .module('app.intro')
        .controller('IntroController', IntroController);

    IntroController.$inject = [
        '$state', 'logger', 'requestservice', '$stateParams',
        '$q', 'UserModel', '$rootScope', '$timeout', '$scope', 'PreloaderModel', '$', '$mdDialog'
    ];
    /* @ngInject */
    function IntroController($state, logger, requestservice, $stateParams, $q, UserModel,
                             $rootScope, $timeout, $scope, PreloaderModel, $, $mdDialog) {
        var vm = this;

        vm.menu = {
            goToSignUp: goToSignUp,

            carouselNext: carouselNext,
            carouselPrev: carouselPrev,
            popupTermsOfUse: popupTermsOfUse
        };

        vm.model = {
            listOfIntros: [],
            imagesLoaded: false
        };

        activate();

        function activate() {
            UserModel.api.clear();
            getIntros();
        }

        function getIntros() {
            return requestservice.run('getIntros', {})
                .then(function (received) {
                console.log('Intros');
                console.log(received);
                if (received.data.success === 0) {
                    parseIntros(received);
                }
                return received;
            });
        }

        function parseIntros(received) {
            console.log('parsing_intros');
            vm.model.listOfIntros = received.data.result;
            PreloaderModel.api.preloadImages(vm.model.listOfIntros, 'picture', function() {
                console.log('images loaded');
                vm.model.imagesLoaded = true;
                $scope.$apply();
                $rootScope.$on('owl-carousel-loaded', function(event, id) {
                    console.log('id');
                    console.log(id);
                    if (id === 'sync-carousel-id') {
                        $timeout(function() {
                            $rootScope.$broadcast('show-mt-content');
                        }, 100);
                    }
                });
            });
        }

        function goToSignUp() {
            $state.go('signup');
        }

        function carouselNext() {
            var owl = $('#text-carousel-main');
            owl.trigger('next.owl.carousel');
        }

        function carouselPrev() {
            var owl = $('#text-carousel-main');
            owl.trigger('prev.owl.carousel');
        }

        function popupTermsOfUse() {
            $mdDialog.show({
                controller: 'TermsOfUseController',
                controllerAs: 'vm',
                templateUrl: 'app/popover/terms_of_use.html',
                //parent: angular.element($document.body),
                clickOutsideToClose: true,
                scope: $rootScope.$new()
            });
        }

    }
})();
