/*
 * EventBot API
 * Version 0.1
 */

var eventbot_base_url = 'http://eventbot.dryft.net';

var eventbot = {
  current_events: function(callback) {
    $.getJSON(eventbot_base_url + "/api/current_events",
        function(data, textStatus) {
          callback(data);
        }
    )
  },

  election_candidates: function(callback) {
    $.getJSON(eventbot_base_url + "/api/election_candidates",
        function(data, textStatus) {
          callback(data);
        }
    )
  },

  event_url_from_id: function(id) {
    return(eventbot_base_url + '/event/view/' + id);
  },
};


