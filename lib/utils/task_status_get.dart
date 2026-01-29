String getChipName(int status) {
  return switch (status) {
    1 => "Completed",
    2 => "Cancelled",
    _ => "In Progress",
  };
}

String getMenuName(int status) {
  return switch (status) {
    1 => "Complete",
    2 => "Cancel",
    _ => "Restart",
  };
}
