require 'account'

describe Account do
  subject { described_class.new }
  context '#balance' do
    it 'starts with a default nil balance' do
      expect(subject.balance).to be(0.0)
    end
    it 'allows a starting balance to be passed in at initialization' do
      account = described_class.new(3000.0)
      expect(account.balance).to be(3000.0)
    end
  end
  context '#deposit' do
    it 'adds to the balance when a deposit is made' do
      expect{subject.deposit(100)}.to change{subject.balance}.by(100)
    end
    it 'adds to the balance when multiple deposits are made' do
      5.times do
        subject.deposit(100)
      end
      expect(subject.balance).to be(500.0)
    end
  end
  context '#withdraw' do
    it 'deducts from the balance when a withdrawal is made' do
      subject.deposit(100)
      expect{subject.withdraw(50)}.to change{subject.balance}.by(-50)
    end
    it 'deducts from the balance when multiple withdrawals are made' do
      subject.deposit(500)
      5.times do
        subject.withdraw(50.25)
      end
      expect(subject.balance).to be(248.75)
    end
    it 'raises an error when trying to withdraw an amount greater than the balance' do
      expect{subject.withdraw(100)}.to raise_error("Insufficient balance")
    end
  end
  context '#account_history' do
    context 'deposits' do
      it 'stores deposit amounts' do
        subject.deposit(100.0)
        expect(subject.account_history.first.has_value?(100.0)).to be true
      end
      it 'stores the dates a deposit was made on' do
        subject.deposit(100.0)
        expect(subject.account_history.first.has_key?(Date.today)).to be true
      end
      it 'stores multiple deposits' do
        subject.deposit(100.0)
        subject.deposit(500.0)
        expect(subject.account_history[0].has_value?(100.0) && subject.account_history[1].has_value?(500.0)).to be true
      end
    end
    context 'withdrawals' do
      it 'stores withdrawal amounts' do
        subject.deposit(200.0)
        subject.withdraw(100.0)
        expect(subject.account_history[1].has_value?(-100.0)).to be true
      end
      it 'stores the dates a withdrawal was made on' do
        subject.deposit(200.0)
        subject.withdraw(100.0)
        expect(subject.account_history[1].has_key?(Date.today)).to be true
      end
      it 'stores multiple withdrawals' do
        subject.deposit(1000.0)
        subject.withdraw(100.0)
        subject.withdraw(500.0)
        expect(subject.account_history[1].has_value?(-100.0) && subject.account_history[2].has_value?(-500.0)).to be true
      end
    end
  end
  context '#statement' do
    it 'prints a statement to the terminal' do
      subject.deposit(1000.0)
      subject.deposit(2000.0)
      subject.withdraw(500.0)
      expect{subject.statement}.to output.to_stdout
    end
  end
end
