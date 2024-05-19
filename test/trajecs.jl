@testset "Trajectories" begin
  @testset "CylindricalTrajectory" begin
    s = Segment(point(0, 0, 0), point(0, 0, 1))
    c = [s(t) for t in range(T(0), stop=T(1), length=10)]
    t = CylindricalTrajectory(c)
    @test eltype(t) <: Cylinder
    @test nelements(t) == 10
    @test radius(t) == T(1) * u"m"
    @test topology(t) == GridTopology(10)

    b = BezierCurve([point(0, 0, 0), point(3, 3, 0), point(3, 0, 7)])
    c = [b(t) for t in range(T(0), stop=T(1), length=20)]
    t = CylindricalTrajectory(c, T(2))
    @test eltype(t) <: Cylinder
    @test nelements(t) == 20
    @test radius(t) == T(2) * u"m"
    @test topology(t) == GridTopology(20)

    # trajectory with single cylinder
    t = CylindricalTrajectory([point(0, 0, 0)], T(1))
    @test eltype(t) <: Cylinder
    @test nelements(t) == 1
    @test radius(t) == T(1) * u"m"
    @test topology(t) == GridTopology(1)
    @test t[1] == Cylinder(point(0, 0, -0.5), point(0, 0, 0.5), T(1))
  end
end
