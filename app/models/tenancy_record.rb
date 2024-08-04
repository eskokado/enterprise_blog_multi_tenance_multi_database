class TenancyRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :tenancy }
end
