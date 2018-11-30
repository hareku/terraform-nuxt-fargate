# #####################################
# # CodeCommit Settings
# #####################################
resource "aws_codecommit_repository" "application" {
  repository_name = "${local.app_name}-application"
}
