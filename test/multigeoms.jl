@testset "Multi" begin
  outer = point.([(0, 0), (1, 0), (1, 1), (0, 1)])
  hole1 = point.([(0.2, 0.2), (0.4, 0.2), (0.4, 0.4), (0.2, 0.4)])
  hole2 = point.([(0.6, 0.2), (0.8, 0.2), (0.8, 0.4), (0.6, 0.4)])
  poly = PolyArea([outer, hole1, hole2])
  multi = Multi([poly, poly])
  @test multi == multi
  @test multi ≈ multi
  @test paramdim(multi) == 2
  @test vertex(multi, 1) == vertex(poly, 1)
  @test vertices(multi) == [vertices(poly); vertices(poly)]
  @test nvertices(multi) == nvertices(poly) + nvertices(poly)
  @test boundary(multi) == merge(boundary(poly), boundary(poly))
  @test rings(multi) == [rings(poly); rings(poly)]

  poly1 = PolyArea(point.([(0, 0), (1, 0), (1, 1), (0, 1)]))
  poly2 = PolyArea(point.([(1, 1), (2, 1), (2, 2), (1, 2)]))
  multi = Multi([poly1, poly2])
  @test vertices(multi) == [vertices(poly1); vertices(poly2)]
  @test nvertices(multi) == nvertices(poly1) + nvertices(poly2)
  @test area(multi) == area(poly1) + area(poly2)
  @test perimeter(multi) == perimeter(poly1) + perimeter(poly2)
  @test centroid(multi) == point(1, 1)
  @test point(0.5, 0.5) ∈ multi
  @test point(1.5, 1.5) ∈ multi
  @test point(1.5, 0.5) ∉ multi
  @test point(0.5, 1.5) ∉ multi
  @test sprint(show, multi) == "Multi(2×PolyArea)"
  @test sprint(show, MIME"text/plain"(), multi) == """
  MultiPolyArea
  ├─ PolyArea((x: 0.0 m, y: 0.0 m), ..., (x: 0.0 m, y: 1.0 m))
  └─ PolyArea((x: 1.0 m, y: 1.0 m), ..., (x: 1.0 m, y: 2.0 m))"""

  box1 = Box(point(0, 0), point(1, 1))
  box2 = Box(point(1, 1), point(2, 2))
  mbox = Multi([box1, box2])
  mchn = boundary(mbox)
  noth = boundary(mchn)
  @test mchn isa Multi
  @test isnothing(noth)
  @test length(mchn) == T(8) * u"m"
  @test sprint(show, mbox) == "Multi(2×Box)"
  @test sprint(show, MIME"text/plain"(), mbox) == """
  MultiBox
  ├─ Box(min: (x: 0.0 m, y: 0.0 m), max: (x: 1.0 m, y: 1.0 m))
  └─ Box(min: (x: 1.0 m, y: 1.0 m), max: (x: 2.0 m, y: 2.0 m))"""

  # constructor with iterator
  grid = cartgrid(10, 10)
  multi = Multi(grid)
  @test parent(multi) == collect(grid)

  # boundary of multi-3D-geometry
  box1 = Box(point(0, 0, 0), point(1, 1, 1))
  box2 = Box(point(1, 1, 1), point(2, 2, 2))
  mbox = Multi([box1, box2])
  mesh = boundary(mbox)
  @test mesh isa Mesh
  @test nvertices(mesh) == 16
  @test nelements(mesh) == 12

  # unique vertices
  poly = PolyArea(point.([(0, 0), (1, 0), (1, 1), (0, 1)]))
  quad = Quadrangle(point(0, 0), point(1, 0), point(1, 1), point(0, 1))
  multi = Multi([poly, quad])
  @test unique(multi) == multi
  @test sprint(show, multi) == "Multi(1×PolyArea, 1×Quadrangle)"
  @test sprint(show, MIME"text/plain"(), multi) == """
  MultiPolygon
  ├─ PolyArea((x: 0.0 m, y: 0.0 m), ..., (x: 0.0 m, y: 1.0 m))
  └─ Quadrangle((x: 0.0 m, y: 0.0 m), ..., (x: 0.0 m, y: 1.0 m))"""

  # type aliases
  p = point(0, 0)
  segm = Segment(point(0, 0), point(1, 1))
  rope = Rope(point.([(0, 0), (1, 0), (1, 1)]))
  ring = Ring(point.([(0, 0), (1, 0), (1, 1)]))
  tri = Triangle(point(0, 0), point(1, 0), point(1, 1))
  poly = PolyArea(point.([(0, 0), (1, 0), (1, 1), (0, 1)]))
  @test Multi([p, p]) isa MultiPoint
  @test Multi([segm, segm]) isa MultiSegment
  @test Multi([rope, rope]) isa MultiRope
  @test Multi([ring, ring]) isa MultiRing
  @test Multi([tri, tri]) isa MultiPolygon
  @test Multi([poly, poly]) isa MultiPolygon
end
