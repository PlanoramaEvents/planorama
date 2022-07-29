desc "Fix missing person from mail history"

namespace :mail do
  task fix_history: :environment do
    MailHistory.all.each do |history|
      email = JSON.parse(history.email).first
      addr = EmailAddress.where("lower(email) = ? and isdefault = true", email.downcase).first
      addr = EmailAddress.where("lower(email) = ?", email.downcase).first unless addr
      puts "** No person for email: #{email}" unless addr
      next unless addr

      if !history.person_id
        history.person_id = addr.person_id
        history.save!(touch: false)
      end
      # break
    end
  end
end
