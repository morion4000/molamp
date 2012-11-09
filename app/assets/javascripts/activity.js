var Activity = {
	no: 0,
	TIMELINE: 0,
	SCROBBLE: 1,
	selector: '.social_activity',
	badge: '.lead .badge',
	
	add: function(obj, mode) {
		var table = $(Activity.selector).find('table tbody'),
			template = Handlebars.compile($("#social-activity-template").html()),
			container = null;

		switch(mode) {
			case Activity.TIMELINE:
				container = template({
					id: obj.id,
					object: obj.artist + ' - ' + obj.track,
					action: 'was shared with your friends on Facebook',
					remove_link: 'javascript:Activity.remove("' + obj.id + '", ' + Activity.TIMELINE + ')',
					remove_text: 'Remove from Timeline'
				});
			break;
			
			case Activity.SCROBBLE:
				container = template({
					id: obj.id,
					object: obj.artist + ' - ' + obj.track,
					action: 'was posted on your Last.fm account',
					remove_link: 'javascript:Activity.remove("' + obj.id + '", ' + Activity.SCROBBLE + ')',
					remove_text: 'Remove'
				});	
			break; 
		}
		
		table.prepend(container);
		
		Activity.no++;
		$(Activity.badge).text(Activity.no);
	},
	
	remove: function(id, mode) {
		var row = $(Activity.selector).find('table tbody').find('tr[id='+id+']');
		
		row.css('background-color', '#ADD8E6');
		
		switch(mode) {
			case Activity.TIMELINE:
				$.ajax('/ajax/activity/delete?id='+id).done(function(data) {
					row.remove();
				});
			break;
			
			default:
				row.remove();
			break;
		}
		
		Activity.no--;
		$(Activity.badge).text(Activity.no);
	}
};
