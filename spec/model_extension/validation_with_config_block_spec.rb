require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  let(:user) { User.create }
  let(:other_user) { User.create }

  let(:manager) { Manager.create user: user }
  let(:other_manager) { Manager.create user: User.create }
  let(:developer) { Developer.create user: user, boss: manager }

  context "with custom error message without vars" do

    before do
      ForeignKeyValidation.configuration = nil
      ForeignKeyValidation.configure {|c| c.error_message = proc {"CUSTOM MSG!"} }
      Member.send :validate_foreign_keys
    end

    it "does not allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("CUSTOM MSG!")
      expect(developer.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_manager.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("CUSTOM MSG!")
      expect(developer.reload.custom_boss_id).to_not eq(other_manager.id)
    end

  end

  context "with custom error message with vars" do

    before do
      ForeignKeyValidation.configuration = nil
      ForeignKeyValidation.configure {|c| c.error_message = proc {|a,b,c| "#{a} #{b} #{c.id}"} }
      Member.send :validate_foreign_keys
    end

    it "does not allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id boss #{developer.id}")
      expect(developer.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_manager.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id boss #{developer.id}")
      expect(developer.reload.custom_boss_id).to_not eq(other_manager.id)
    end

  end

  context "without injecting subclasses via config block" do

    before do
      ForeignKeyValidation.configuration = nil
      Member.send :validate_foreign_keys
    end

    it "does not allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_manager.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.custom_boss_id).to_not eq(other_manager.id)
    end

  end

  context "with injecting subclasses set to true via config block" do

    before do
      ForeignKeyValidation.configuration = nil
      ForeignKeyValidation.configure {|c| c.inject_subclasses = true }
      Member.send :validate_foreign_keys
    end

    it "does not allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_manager.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.custom_boss_id).to_not eq(other_manager.id)
    end

  end


  context "with injecting subclasses set to false via config block" do

    before do
      ForeignKeyValidation.configuration = nil
      ForeignKeyValidation.configure {|c| c.inject_subclasses = false }
      Member.send :validate_foreign_keys
    end

    it "does allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      expect(developer.errors.messages.values.flatten).to_not include("user_id of boss does not match developers user_id.")
      expect(developer.reload.user_id).to eq(other_user.id)
    end

    it "does allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_manager.id
      developer.save
      expect(developer.errors.messages.values.flatten).to_not include("user_id of boss does not match developers user_id.")
      expect(developer.reload.custom_boss_id).to eq(other_manager.id)
    end

  end

end
