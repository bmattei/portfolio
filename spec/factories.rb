FactoryBot.define do
  factory :groupings_ticker do
    
  end
  factory :admin_user do
    Names = %w(Sally, Sarah, Sam, Tom, Bill, Barbara, Casey, Slim, Joe, Gini, Terry, Alan, Dave, Lisa, Alyssa, Phil, Jane, Mary, Anna, Isa, Karina)
    sequence(:email) do |n|
      Names[n % Names.count] + "#{rand(999999999999)}@test.com"
    end
    password { "#{email.split(/@/)[0]}_password" }
    admin false

    factory :admin_user_with_accounts do
      transient do
        account_count 3
      end
      after(:create) do |admin_user, evaluator |
        create_list(:account, evaluator.account_count, admin_user: admin_user)
      end
    end

  end

  factory :ticker do
    symbol {['VBR', 'TLT', 'SCHR', 'SCHO', 'IBM', 'AAPL', 'GE', 'HCN', 'SCHP', 'DGS', 'EFV', 'IEFA', 'SCHB', 'SCHE',
             'AVA', 'CM', 'COP', 'DE', 'JNJ', 'CVX', 'O', 'RY', 'PM', 'SO', 'MAIN', ].sample }
    name {"#{symbol}" }
  end


  factory :holding do
    association :ticker
    shares {[10, 11, 101, 1000, 3400, 25, 45].sample}
  end

  
  factory :account do
    association  :holding
    Brokers = ['Etrade', 'Fidelity', 'Vanguard']
    Types = [AccountType::Taxable, AccountType::TaxDeferred, AccountType::TaxFree]  
    sequence(:name) {|n| "accountName#{n}" }
    sequence(:account_number) {|n| "000000000#{n}" }
    sequence(:brokerage) { |n| Brokers[n % Brokers.count] }
    sequence(:account_type_id) { |n| Types[n % Types.count] }
    sequence(:cash) { |n| n * 111 }
  end

    


  
end
