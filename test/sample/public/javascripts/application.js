function Notification($http) {
  return {
    index: function (success, error) {
      var request = $http.get('/notifications.json');
      if (success) request.success(success);
      if (error) request.error(error);
      return request;
    }
  };
}

function NotificationListCtrl($scope, Notification) {
  $scope.toggleNotifications = function () {
    if ($scope.notifications) {
      $scope.notifications = null;
    } else {
      Notification.index(function (notifications) {
          $scope.notifications = notifications;
      });
    }
  };
}

angular.module('sample', [])
    .service('Notification', Notification)
    .controller('NotificationListCtrl', NotificationListCtrl);
