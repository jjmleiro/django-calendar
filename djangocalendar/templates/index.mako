## Licensed to the Apache Software Foundation (ASF) under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  The ASF licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
## http:# www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

<%!
  from djangocalendar import settings
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Django Calendar</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/x-icon" href="${settings.STATIC_URL}art/logo.png" />
  <meta name="description" content="">
  <meta name="author" content="">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">

  <link rel="stylesheet" href="${settings.STATIC_URL}css/bootstrap.min.css">
  <link rel="stylesheet" href="${settings.STATIC_URL}css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="${settings.STATIC_URL}css/calendar.css">

  <script type="text/javascript" charset="utf-8" src="${settings.STATIC_URL}js/bower_components/jquery/dist/jquery.min.js"></script>
  <script type="text/javascript" charset="utf-8" src="${settings.STATIC_URL}js/bower_components/underscore/underscore-min.js"></script>
  <script type="text/javascript" charset="utf-8" src="${settings.STATIC_URL}js/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
  <script type="text/javascript" charset="utf-8" src="${settings.STATIC_URL}js/bower_components/moment/moment.js"></script>
  <script type="text/javascript" charset="utf-8" src="${settings.STATIC_URL}js/calendar.js"></script>
</head>

<body>
  ${Data}
  <div class="container-fluid">
   <div class="card">        
     <div class="card-body">              

        <div class="container">
    
          <div class="page-header">

            <div class="pull-right form-inline">
              <div class="btn-group">
                <button class="btn btn-primary" data-calendar-nav="prev"><< Prev</button>
                <button class="btn" data-calendar-nav="today">Today</button>
                <button class="btn btn-primary" data-calendar-nav="next">Next >></button>
              </div>
              <div class="btn-group">
                <button class="btn btn-warning" data-calendar-view="year">Year</button>
                <button class="btn btn-warning active" data-calendar-view="month">Month</button>
                <button class="btn btn-warning" data-calendar-view="week">Week</button>
                <button class="btn btn-warning" data-calendar-view="day">Day</button>
              </div>
            </div>

            <h3></h3>
            <small>To see example with events navigate to march 2013</small>
          </div>

          <div class="row">
            <div class="span9">
              <div id="calendar"></div>
            </div>            
          </div>

          <div class="clearfix"></div>
          
          <br><br>

          <div class="modal hide fade" id="events-modal">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h3>Event</h3>
            </div>
            <div class="modal-body" style="height: 400px">
            </div>
            <div class="modal-footer">
              <a href="#" data-dismiss="modal" class="btn">Close</a>
            </div>
          </div>

          
        </div>
     </div>
   </div>
  </div> 

  <script type="text/javascript" charset="utf-8">
    Date.prototype.currentDay = function() {
     var yyyy = this.getFullYear().toString();
     var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
     var dd  = this.getDate().toString();
     return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]); // padding
    };

    var date = new Date();
    var options = {
      events_source: "${settings.STATIC_URL}calendar/events.json.php",
      //events_source: [];
      //events_source : "http://vm4:8888/events/",    
      view: 'month',
      tmpl_path: "${settings.STATIC_URL}calendar/",
      tmpl_cache: false,
      //day: '2013-03-12',
      day: date.currentDay(),
      onAfterEventsLoad: function(events) {
        if(!events) {
          return;
        }
        var list = $('#eventlist');
        list.html('');

        $.each(events, function(key, val) {
          $(document.createElement('li'))
            .html('<a href="' + val.url + '">' + val.title + '</a>')
            .appendTo(list);
        });
      },
      onAfterViewLoad: function(view) {
        $('.page-header h3').text(this.getTitle());
        $('.btn-group button').removeClass('active');
        $('button[data-calendar-view="' + view + '"]').addClass('active');
      },
      classes: {
        months: {
          general: 'label'
        }
      }
    };

    var calendar = $('#calendar').calendar(options);

    $('.btn-group button[data-calendar-nav]').each(function() {
      var $this = $(this);
      $this.click(function() {
        calendar.navigate($this.data('calendar-nav'));
      });
    });

    $('.btn-group button[data-calendar-view]').each(function() {
      var $this = $(this);
      $this.click(function() {
        calendar.view($this.data('calendar-view'));
      });
    });

    $('#first_day').change(function(){
      var value = $(this).val();
      value = value.length ? parseInt(value) : null;
      calendar.setOptions({first_day: value});
      calendar.view();
    });

    $('#language').change(function(){
      calendar.setLanguage($(this).val());
      calendar.view();
    });

    $('#events-in-modal').change(function(){
      var val = $(this).is(':checked') ? $(this).val() : null;
      calendar.setOptions({modal: val});
    });
    $('#format-12-hours').change(function(){
      var val = $(this).is(':checked') ? true : false;
      calendar.setOptions({format12: val});
      calendar.view();
    });
    $('#show_wbn').change(function(){
      var val = $(this).is(':checked') ? true : false;
      calendar.setOptions({display_week_numbers: val});
      calendar.view();
    });
    $('#show_wb').change(function(){
      var val = $(this).is(':checked') ? true : false;
      calendar.setOptions({weekbox: val});
      calendar.view();
    });
    $('#events-modal .modal-header, #events-modal .modal-footer').click(function(e){
      //e.preventDefault();
      //e.stopPropagation();
    });
  </script>
</body>
