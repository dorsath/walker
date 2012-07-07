require 'xmlsimple'
require './lib/model'


@model = Model.new('model.dae').data
p @model[:textures]
