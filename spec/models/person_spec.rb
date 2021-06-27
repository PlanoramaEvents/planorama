require 'rails_helper'

RSpec.describe Person, '#factories' do
    context 'person' do
        it 'creates a basic person' do
            person = create(:person)
            expect(person.invite_status).to eq "not_set"
            expect(person.acceptance_status).to eq "unknown"
            expect(person.email).to_not be_nil
            expect(person.opted_in).to be false
            expect(person.registered).to be false
            expect(person.can_share).to be false
            expect(person.can_photo).to be false
            expect(person.can_record).to be false
        end
        it 'should not create a person with a name' do         #name should be a required field and non-blank
            expect { person = create(:person, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end

    context 'pseudonym_person' do
        it 'creates a person with a pseudonym' do
            person = create(:pseudonym_person)
            expect(person.pseudonym).to_not be nil
            expect(person.pseudonym_sort_by).to_not be nil
        end
    end

    context 'registered_person' do
        it 'creates a registered person' do
            person = create(:registered_person)
            expect(person.registered).to be true
            expect(person.registration_type).to be_truthy
            expect(person.registration_number).to be_truthy
        end
    end
end
