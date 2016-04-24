require 'rspec'
require_relative '../src/Pattern'

describe 'matcher de valor' do

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


describe 'matcher de tipo' do

  it '5 es un integer' do
    expect(type(Integer).call(5)).to be true
  end

  it 'string no es un simbolo' do
    expect(type(Symbol).call("Trust me, I'm a Symbol..")).to be false
  end

  it 'simbolo es un simbolo' do
    expect(type(Symbol).call(:a_real_symbol)).to be true
  end

end