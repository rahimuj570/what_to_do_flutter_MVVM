enum TaskStatusEnum { complete, cancel, inProgress }

String getChipName(TaskStatusEnum te) {
  return switch (te) {
    TaskStatusEnum.complete => "Completed",
    TaskStatusEnum.cancel => "Cancelled",
    TaskStatusEnum.inProgress => "In Progress",
  };
}

String getMenuName(TaskStatusEnum te) {
  return switch (te) {
    TaskStatusEnum.complete => "Complete",
    TaskStatusEnum.cancel => "Cancel",
    TaskStatusEnum.inProgress => "Restart",
  };
}
