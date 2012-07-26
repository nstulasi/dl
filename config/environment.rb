# Load the rails application
require File.expand_path('../application', __FILE__)
require 'will_paginate'

# Initialize the rails application
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
SampleApp::Application.initialize!
