require 'rspec'
require_relative '../src/matcher'

describe '#val' do

  it '5 es igual a 5' do
    expect(val(5).call(5)).to be true
  end

  it '5 no es igual a 4' do
    expect(val(5).call(4)).to be false
  end

  it '5 no es igual a "5"' do
    expect(val(5).call('5')).to be false
  end
end


describe '#type' do

  it '5 es un integer' do
    expect(type(Integer).call(5)).to be true
  end

  it 'string no es un simbolo' do
    expect(type(Symbol).call("Trust me, I'm a Symbol..")).to be false
  end

  it 'simbolo es un simbolo' do
    expect(type(Symbol).call(:a_real_symbol)).to be true
  end

  it '5 es un object' do
    expect(type(Object).call(5)).to be true
  end
end

describe '#list' do
  context 'siendo [1,2,3,4] la lista a comparar' do
    let(:an_array) { [1,2,3,4] }
    context 'teniendo una lista de igual tamaño' do
      context 'y mismos elementos' do
        context 'y match_size true' do
          it 'devuelve true' do
            expect(list([1,2,3,4], true).call(an_array)).to be true
          end
        end

        context 'y match_size false' do
          it 'devuelve false' do
            expect(list([1,2,3,4], false).call(an_array)).to eq true
          end
        end
      end

      context 'pero distintos elementos' do
        context 'y el match_size true' do
          it 'devuelve false' do
            expect(list([1,3,4,2], true).call(an_array)).to be false
          end
        end

        context 'y el match_size false' do
          it 'devuelve false' do
            expect(list([1,3,4,2], false).call(an_array)).to be false
          end
        end
      end
    end

    context 'teniendo una lista de diferente tamaño' do
      context 'y la lista incluida' do
        context 'y match_size true' do
          it 'devuelve false' do
            expect(list([1,2,3], true).call(an_array)).to eq false
          end
        end

        context 'y match_size false' do
          it 'devuelve true' do
            expect(list([1,2,3], false).call(an_array)).to eq true
          end
        end
      end

      context 'y la lista no esta incluida' do
        context 'y el match_size true' do
          it 'devuelve false' do
            expect(list([1,3,2], true).call(an_array)).to eq false
          end
        end

        context 'y el match_size false' do
          it 'devuelve false' do
            expect(list([1,3,2], false).call(an_array)).to eq false
          end
        end
      end
    end

    context 'al no pasarle el match_size' do
      it 'asume que es true' do
        expect(list([1,3,2]).call(an_array)).to eq false
      end
    end
  end
end

describe '#duck' do
  let!(:psyduck) { Object.new }
  before do
    def psyduck.cuack
     'psy..duck?'
    end

    def psyduck.fly
     '(headache)'
    end
  end

  it { expect(duck(:cuack, :fly).call(psyduck)).to be true }
  it { expect(duck(:method_1, :method_2).call(2)).to be false }
  it { expect(duck(:class).call(3)).to be true }
  it { expect(duck(:to_s).call(Object.new)).to be true }
end

describe '#and' do
  it { expect(type(Object).and(type(Fixnum)).call(2)).to be true }
  it { expect(duck(:+).and(type(Fixnum), val(5)).call(5)).to be true }
  it { expect(duck(:some_method).and(type(Object)) .call("hola")).to be false }
end

describe '#or' do
  it { expect(type(Fixnum).or(type(Object)).call('hola')).to be true }
  it { expect(duck(:some_method).or(type(Fixnum)).call('hola')).to be false }
end

describe '#not' do
  it { expect(type(Integer).not.call(5)).to be false }
  it { expect(duck(:method_2).not.call(Object.new)).to be true }
end