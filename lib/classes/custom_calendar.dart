enum EventCategory {
  mine,
  yours,
  ours,
}

class EventDetail {
  EventCategory category;
  String? repeat;

  EventDetail({
    required this.category,
    this.repeat,
  });
}
