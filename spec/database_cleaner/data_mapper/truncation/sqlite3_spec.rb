require 'spec_helper'
require 'dm-core'
require 'dm-sqlite-adapter'
require 'support/data_mapper/sqlite3_setup'
require 'database_cleaner/data_mapper/truncation'

module DataMapper
  module ConnectionAdapters
    describe do
      before(:all) { DataMapperSQLite3Helper.data_mapper_sqlite3_setup }

      let(:adapter) { DataMapperSQLite3Adapter }

      let(:connection) do
        DataMapperSQLite3Helper.data_mapper_sqlite3_connection
      end

      before(:each) do
        connection.truncate_tables(DataMapper::Model.descendants.map { |d| d.storage_names[:default] || d.name.underscore })
      end

      describe "#truncate_table" do
        it "truncates the table" do
          2.times { DmUser.create }

          connection.truncate_table(DmUser.storage_names[:default])
          expect(DmUser.count).to eq 0
        end

        it "resets AUTO_INCREMENT index of table" do
          2.times { DmUser.create }
          DmUser.destroy

          connection.truncate_table(DmUser.storage_names[:default])

          expect(DmUser.create.id).to eq 1
        end
      end
    end
  end
end
