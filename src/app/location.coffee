class LocationRoutes extends Config
    constructor: ($stateProvider, $urlRouterProvider) ->
        $urlRouterProvider
            .when('/l', '/location')

        $stateProvider
            .state('location_lookup',
                url: '/location'
                views:
                    '':
                        templateUrl: 'location.html'
                        controller: 'locationController'
                    'header':
                        template: 'Choose Your Location'
            )

# location lookup and state manager
class Location extends Controller
    constructor: ($scope, $state, geolocation) ->
        $scope.button_text = 'looking you up…'
        $scope.searching = false
        # geo object
        $scope.location = false

        $scope.existing_locations = {
            # North Tulsa - N Hartford and E Virgin
            'North Tulsa': {lat: 36.184799, lng: -95.984105}
            # Midtown - 25th and Utica
            'Midtown Tulsa': {lat: 36.125700, lng: -95.967581}
            # South Tulsa - 85th and South Pittsburgh
            'South Tulsa': {lat: 36.039897, lng: -95.932032}
        }

        # get the user's current location
        $scope.get_location = ->
            return if $scope.searching is true
            $scope.searching = true
            $scope.location_promise = geolocation.getLocation()
            $scope.location_promise.then (geo) ->
                $scope.location = {lat: geo.coords.latitude, lng: geo.coords.longitude}
                $scope.searching = false
                $scope.button_text = 'Use current location'
            , (error) ->
                $scope.button_text = error

        $scope.get_location()

        # accepts lat/lng obj
        $scope.retreive_location = (location) ->
            $state.go('score', location)
