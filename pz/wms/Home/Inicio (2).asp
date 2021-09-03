
<link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>



<div class="row border-bottom white-bg dashboard-header">

    <div class="col-md-8">
        <h2>Calendario de eventos</h2>
        <small>&nbsp; </small>
                <div id="calendario"></div>
       

    </div>
    
    <div class="col-md-4 white-bg " id="dvAvisos"></div>
    <!--   div class="col-md-4 white-bg " >    
         <div class="ibox float-e-margins">
                   <div class="ibox-title">
                        <h5>Nuevos mensajes</h5>
                        <div class="ibox-tools">
                            <span class="label label-warning-light pull-right">10 Mensajes</span>
                        </div>
                    </div>
                    <div class="ibox-content">

                            <div class="feed-activity-list">

                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/profile.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right">5m ago</small>
                                        <strong>Monica Smith</strong> posted a new blog. <br>
                                        <small class="text-muted">Today 5:60 pm - 12.06.2014</small>

                                    </div>
                                </div>

                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/a2.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right">2h ago</small>
                                        <strong>Mark Johnson</strong> posted message on <strong>Monica Smith</strong> site. <br>
                                        <small class="text-muted">Today 2:10 pm - 12.06.2014</small>
                                    </div>
                                </div>
                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/a3.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right">2h ago</small>
                                        <strong>Janet Rosowski</strong> add 1 photo on <strong>Monica Smith</strong>. <br>
                                        <small class="text-muted">2 days ago at 8:30am</small>
                                    </div>
                                </div>
                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/a4.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right text-navy">5h ago</small>
                                        <strong>Chris Johnatan Overtunk</strong> started following <strong>Monica Smith</strong>. <br>
                                        <small class="text-muted">Yesterday 1:21 pm - 11.06.2014</small>
                                        <div class="actions">
                                            <a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> Like </a>
                                            <a class="btn btn-xs btn-white"><i class="fa fa-heart"></i> Love</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/a5.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right">2h ago</small>
                                        <strong>Kim Smith</strong> posted message on <strong>Monica Smith</strong> site. <br>
                                        <small class="text-muted">Yesterday 5:20 pm - 12.06.2014</small>
                                        <div class="well">
                                            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
                                            Over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                                        </div>
                                        <div class="pull-right">
                                            <a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> Like </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/profile.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right">23h ago</small>
                                        <strong>Monica Smith</strong> love <strong>Kim Smith</strong>. <br>
                                        <small class="text-muted">2 days ago at 2:30 am - 11.06.2014</small>
                                    </div>
                                </div>
                                <div class="feed-element">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="/Template/inspina/img/a7.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right">46h ago</small>
                                        <strong>Mike Loreipsum</strong> started following <strong>Monica Smith</strong>. <br>
                                        <small class="text-muted">3 days ago at 7:58 pm - 10.06.2014</small>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block m-t"><i class="fa fa-arrow-down"></i> Ir a mensajes</button>

                    </div>
                <div>
        </div>
</div>
    
    </div   -->
    
</div>




<!-- jQuery UI  -->
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<!-- iCheck -->
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<!-- Full Calendar -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<script src="/Template/inspina/js/plugins/i18next/es.js"></script>


<script>

    $(document).ready(function() {
    
 /* initialize the calendar
    ---------------------------------------*/
        var date = new Date();
        var d = date.getDate();
        var m = date.getMonth();
        var y = date.getFullYear();

        
       $('#calendario').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            editable: true,
            droppable: true, // this allows things to be dropped onto the calendar
            drop: function() {
                // is the "remove after drop" checkbox checked?
                if ($('#drop-remove').is(':checked')) {
                    // if so, remove the element from the "Draggable Events" list
                    $(this).remove();
                }
            },
            events: [
                {
                    title: 'All Day Event',
                    start: new Date(y, m, 1)
                },
                {
                    title: 'Long Event',
                    start: new Date(y, m, d-5),
                    end: new Date(y, m, d-2)
                },
                {
                    id: 999,
                    title: 'Repeating Event',
                    start: new Date(y, m, d-3, 16, 0),
                    allDay: false
                },
                {
                    id: 999,
                    title: 'Repeating Event',
                    start: new Date(y, m, d+4, 16, 0),
                    allDay: false
                },
                {
                    title: 'Meeting',
                    start: new Date(y, m, d, 10, 30),
                    allDay: false
                },
                {
                    title: 'Lunch',
                    start: new Date(y, m, d, 12, 0),
                    end: new Date(y, m, d, 14, 0),
                    allDay: false
                },
                {
                    title: 'Birthday Party',
                    start: new Date(y, m, d+1, 19, 0),
                    end: new Date(y, m, d+1, 22, 30),
                    allDay: false
                },
                {
                    title: 'Click for Google',
                    start: new Date(y, m, 28),
                    end: new Date(y, m, 29),
                    url: 'http://google.com/'
                }
            ]
        });
        
        
		$("#dvAvisos").load("/pz/agt/Inicio/Avisos.asp?Usu_ID=" + $("#IDUsuario").val() )
		
		
  });

</script>