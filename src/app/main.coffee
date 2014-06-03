class Ham extends App
    # requirements for the app
    @constructor = [
        # 'ngAnimate'
        'ui.router'
        'geolocation'
    ]


class RunState extends Run
    constructor: ($log, $rootScope, $state, $stateParams) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams
        # navigate to the home state on init
        $state.transitionTo('home')

        $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
            $log.log('$stateChangeStart', arguments)
        $rootScope.$on '$stateNotFound', (event, unfoundState, fromState, fromParams) ->
            $log.log('$stateNotFound', arguments)
        $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
            $log.log('$stateChangeSuccess', arguments)
        $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
            $log.log('$stateChangeError', arguments)

        # main menu
        $rootScope.enable_menu = false
        $rootScope.toggle_menu = ->
            $rootScope.enable_menu = !$rootScope.enable_menu


class Routes extends Config
    constructor: ($stateProvider, $urlRouterProvider, $locationProvider) ->
        # $locationProvider.html5Mode(true)

        $urlRouterProvider
          # The `when` method says if the url is ever the 1st param, then redirect to the 2nd param
          # Here we are just setting up some convenience urls.
          # .when('/c?id', '/contacts/:id')
          # .when('/user/:id', '/contacts/:id')
          # If the url is ever invalid, e.g. '/asdf', then redirect to '/' aka the home state
          .otherwise('/')

        $stateProvider
            .state('home',
                url: '/'
                views:
                    '':
                        templateUrl: 'home.html'
                    'header':
                        template: 'Welcome to HealthAround.me'
            )
            .state('about',
                url: '/about'
                views:
                    '':
                        templateUrl: 'about.html'
                    'header':
                        template: 'About HealthAround.me'
            )
