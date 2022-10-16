# frozen_string_literal: true

require_relative 'printer'

# Class handling saving and loading of the game
class SaveLoad
  include Printer

  def save(game)
    make_save_dir
    savefile_name = collect_and_check_savefile_name
    create_savefile(game, savefile_name)
    succesful_save_message
    exit(true)
  end

  def savefile_name_valid?(savefile_name)
    savefile_name.split('').all? { |letter| letter.ord.between?(97, 122) } && savefile_name.length < 13
  end

  def create_savefile(game, savefile_name = 'test')
    File.open("saves/#{savefile_name}.yml", 'w') { |file| YAML.dump(game, file) }
  end

  def make_save_dir
    Dir.mkdir('saves') unless File.exist?('saves')
  end

  def load
    unless File.exist?('saves') && !Dir.empty?('saves')
      no_directory_message
      return nil
    end
    loadfile_name = collect_loadfile_name
    export_loaded_data(loadfile_name)
  end

  def export_loaded_data(loadfile_name)
    File.open("saves/#{loadfile_name}.yml", 'r') do |file|
      YAML.safe_load(file, permitted_classes: [Game, Board, Player, Piece], aliases: true)
    end
  end
end
