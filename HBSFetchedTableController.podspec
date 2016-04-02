#
#  Be sure to run `pod spec lint HBSFetchedTableController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HBSFetchedTableController"
  s.version      = "1.0.2"
  s.summary      = "A layer between UITableView and NSFetchedResultsController."
  s.description  = "Layer between CoreData's NSFetchedResultsController and UITableView. Incapsulates all boilerplate code, and let you split your code by logic - configuration factories and behaviour delegates."

  s.homepage     = "https://github.com/RealBonus/HBSFetchedTableController"
  s.license      = "MIT"
  s.author             = { "Pavel Anokhov" => "p.anokhov@gmail.com" }
  s.social_media_url   = "https://www.instagram.com/pavel_anokhov/"

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.framework  = 'CoreData', 'UIKit'

  s.source       = { :git => "https://github.com/RealBonus/HBSFetchedTableController.git", :tag => s.version.to_s }
  s.source_files  = "Pod/Classes/**/*"

end
