# frozen_string_literal: true

namespace :email_address_migration do
  desc "Migrate emails from Teacher to EmailAddress model (no deletion of emails from Teacher model), with comprehensive logging"
  task migrate_email_addresses: :environment do
    total_emails = 0
    migrated_emails = 0
    failed_emails = []
    skipped_emails = 0
    warnings = []

    Teacher.find_each do |teacher|
      puts "[INFO] Processing Teacher ID: #{teacher.id}, Name: #{teacher.first_name} #{teacher.last_name}"
      emails = [teacher[:email], teacher[:personal_email]].compact

      if emails.empty?
        warnings << "[WARN] Skipping Teacher ID: #{teacher.id} - No emails to process."
        puts warnings.last
        skipped_emails += 1
        next
      end

      emails.each do |email|
        if email.blank?
          warnings << "[WARN] Blank email found for Teacher ID: #{teacher.id}, skipping this entry."
          puts warnings.last
          skipped_emails += 1
          next
        end

        if EmailAddress.find_by(email: email.strip.downcase).present?
          warnings << "[ERROR] Duplicate email '#{email}' ('#{email.strip.downcase}' ) for Teacher ID: #{teacher.id}, skipping this entry."
          puts warnings.last
          skipped_emails += 1
          next
        end

        total_emails += 1
        primary = email == teacher[:email]
        email_record = EmailAddress.new(teacher_id: teacher.id, email:, primary:)

        if email_record.save
          migrated_emails += 1
          puts "[INFO] Successfully migrated email #{email} for Teacher ID: #{teacher.id}"
        else
          puts "[ERROR] Failed to migrate email #{email} for Teacher ID: #{teacher.id}: #{email_record.errors.full_messages.join(", ")}"
          failed_emails << { email: email, errors: email_record.errors.full_messages }
          # Explicit log to indicate the failed email remains with the Teacher model
          puts "[INFO] Failed email #{email} remains at Teacher model and has not been removed due to migration errors."
        end
      end
    end

    puts "\n\n" + "=" * 50
    puts "[INFO] Migration summary: Total emails processed: #{total_emails}, Migrated: #{migrated_emails}, Failed: #{failed_emails.size}, Skipped: #{skipped_emails}; Warning Messages: #{warnings.length}"
    if failed_emails.any?
      puts "[INFO] Detailed failed migrations:"
      failed_emails.each do |fail|
        puts "[ERROR] Failed email: #{fail[:email]}, Errors: #{fail[:errors].join(", ")}"
      end
    end

    if warnings.present?
      warnings.each { |msg| puts msg }
    end
  end
end
