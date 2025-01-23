import dash
from dash import html, dcc
import geopandas as gpd
import plotly.graph_objects as go
import json

app = dash.Dash(__name__)

gdf = gpd.read_file("dataset/building/Building_Footprints.shp")

gdf = gdf.to_crs(epsg=4326)

print("got gdf")

simplified_gdf = gdf.simplify(tolerance=0.00001)
geojson_data = json.loads(simplified_gdf.to_json())

fig = go.Figure()

print(f"starting trace {gdf.index}")

fig.add_trace(
    go.Choroplethmapbox(
        geojson=geojson_data,
        locations=gdf.index,
        z=gdf.index,
        colorscale=[[0, "rgb(65, 105, 225)"], [1, "rgb(65, 105, 225)"]],
        showscale=False,
        marker={"opacity": 0.7, "line": {"width": 0.5, "color": "rgb(40, 40, 40)"}},
        hoverinfo="none",
    )
)

print("end trace")

fig.update_layout(
    mapbox=dict(
        style="open-street-map",  # 'carto-positron',
        center=dict(lon=-77.0369, lat=38.9072),  # DC center coordinates
        zoom=13,
    ),
    margin=dict(l=0, r=0, t=0, b=0),
    height=800,
    paper_bgcolor="white",
    plot_bgcolor="white",
)

app.layout = html.Div(
    [
        html.H1(
            "DC Building Footprints Map",
            style={"textAlign": "center", "margin": "20px", "fontFamily": "Arial"},
        ),
        html.Div(
            "Loading map... wait rendering over 160,000 buildings.",
            style={
                "textAlign": "center",
                "margin": "10px",
                "color": "#666",
                "fontFamily": "Arial",
            },
        ),
        dcc.Graph(id="dc-buildings-map", figure=fig, style={"height": "80vh"}),
    ]
)

if __name__ == "__main__":
    print("runserver")
    app.run_server(debug=True)
