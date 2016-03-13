Transit = mojs.Transit
Swirl   = mojs.Swirl

tr = new Transit
describe 'Swirl ->', ->
  describe 'extension ->', ->
    it 'should extend Transit class', ->
      swirl = new Swirl
      expect(swirl instanceof Transit).toBe true
    it 'should have _skipPropsDelta', ->
      swirl = new Swirl
      expect(swirl._skipPropsDelta.x).toBe 1
      expect(swirl._skipPropsDelta.y).toBe 1
    it 'should have angleShift value', ->
      swirl = new Swirl
        x: {0:10}, y: {0:10}
        isSwirlLess: true, angleShift: 90
      expect(swirl._props.angleShift).toBe 90
  describe 'position calc ->', ->
    it 'should calc position radius', ->
      swirl = new Swirl x: {0:10}, y: {0:20}
      expect(swirl.positionDelta.radius).toBe Math.sqrt (10*10 + 20*20)
    it 'should calc position angle', ->
      swirl = new Swirl x: {0:10}, y: {0:10}
      expect(swirl.positionDelta.angle).toBe 135
    it 'should calc position angle', ->
      swirl = new Swirl x: {0:-10}, y: {0:-10}
      expect(swirl.positionDelta.angle).toBe - 45
    it 'should calc position angle', ->
      swirl = new Swirl x: {0:0}, y: {0:-10}
      expect(swirl.positionDelta.angle).toBe 0
    it 'should calc position angle', ->
      swirl = new Swirl x: {0:-10}, y: {0:0}
      expect(swirl.positionDelta.angle).toBe 270
    it 'should save startX and StartY values', ->
      swirl = new Swirl x: {0:10}, y: {10:10}
      expect(swirl.positionDelta.x.start).toBe 0
      expect(swirl.positionDelta.y.start).toBe 10
    it 'should set start position anyways', ->
      swirl = new Swirl x: {0:10}, y: 0
      expect(swirl._props.x).toBe '0.0000px'
      expect(swirl._props.y).toBe '0.0000px'
    it 'should call super _extendDefaults method', ->
      swirl = new Swirl radius: [{ 20: 50 }, 20]
      spyOn Swirl.__super__, '_extendDefaults'
      swirl._extendDefaults()
      expect(Swirl.__super__._extendDefaults).toHaveBeenCalled()

  describe '_setProgress ->', ->
    it 'should call super _setProgress method', ->
      swirl = new Swirl radius: [{ 20: 50 }, 20]
      spyOn Swirl.__super__, '_setProgress'
      swirl._setProgress .5
      expect(Swirl.__super__._setProgress).toHaveBeenCalledWith .5
    it 'should set x/y progress', ->
      swirl = new Swirl x: {0:10}, y: {0:10}, isSwirlLess: true
      swirl._setProgress .5
      expect(swirl._props.x).toBe '5.0000px'
      expect(swirl._props.y).toBe '5.0000px'
    it 'should set x/y progress', ->
      swirl = new Swirl x: {0:10}, y: {0:10}, isSwirlLess: true
      swirl._setProgress 1
      expect(swirl._props.x).toBe '10.0000px'
      expect(swirl._props.y).toBe '10.0000px'
    it 'should set negative x/y progress', ->
      swirl = new Swirl
        x: {0:'-10'}, y: {0:'-10'}, isSwirlLess: true
      swirl._setProgress 1
      expect(swirl._props.x).toBe '-10.0000px'
      expect(swirl._props.y).toBe '-10.0000px'
    it 'should set plain x/y progress if foreign context', ->
      swirl = new Swirl
        x: {0:10}, y: {0:10}, ctx: tr.ctx, isSwirlLess: true
      swirl._setProgress 1
      expect(swirl._props.x+'').toBe '10.0000'
      expect(swirl._props.y+'').toBe '10.0000'
    it 'should respect radiusScale value', ->
      swirl = new Swirl
        x: {0:10}, y: {0:10},
        isSwirlLess: true, radiusScale: .5
      swirl._setProgress 1
      expect(swirl._props.x).toBe '5.0000px'
      expect(swirl._props.y).toBe '5.0000px'
    it 'should not add swirl', ->
      swirl = new Swirl x: {0:10}, y: {0:10}
      swirl._setProgress .5
      expect(swirl._props.x).toBe '5.0000px'
      expect(swirl._props.y).toBe '5.0000px'
    it 'should add swirl if isSwirl', ->
      swirl = new Swirl x: {0:10}, y: {0:10}, isSwirl: true
      swirl._setProgress .5
      expect(swirl._props.x).not.toBe '5.0000px'
      expect(swirl._props.y).not.toBe '5.0000px'
  describe 'generateSwirl method ->', ->
    it 'should generate simple swirl', ->
      swirl = new Swirl swirlSize: 3, swirlFrequency: 2
      swirl.generateSwirl()
      expect(swirl._props.swirlSize).toBe      3
      expect(swirl._props.swirlFrequency).toBe 2
    it 'should generate rand swirl', ->
      swirl = new Swirl swirlSize: 'rand(10,20)', swirlFrequency: 'rand(3,7)'
      swirl.generateSwirl()
      expect(swirl._props.swirlSize).toBeGreaterThan     9
      expect(swirl._props.swirlSize).not.toBeGreaterThan 20
    it 'should not generate simple swirl is isSwirlLess was passed', ->
      swirl = new Swirl isSwirlLess: true
      spyOn swirl, 'generateSwirl'
      swirl._vars()
      expect(swirl.generateSwirl).not.toHaveBeenCalled()
  describe 'getSwirl method ->', ->
    it 'should calc swirl based on swirlFrequency and swirlSize props', ->
      swirl = new Swirl
      swirl1 = swirl.getSwirl(.5)
      freq = Math.sin(swirl._props.swirlFrequency*.5)
      sign = swirl._props.signRand
      expect(swirl1).toBe sign*swirl._props.swirlSize*freq
