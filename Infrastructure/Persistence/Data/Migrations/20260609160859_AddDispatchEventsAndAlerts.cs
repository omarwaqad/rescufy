using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddDispatchEventsAndAlerts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "DispatchAlerts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AlertId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Level = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Zone = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Recommendation = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DispatchAlerts", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DriverFeedbacks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DriverId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    RequestId = table.Column<int>(type: "int", nullable: false),
                    Rate = table.Column<int>(type: "int", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DriverFeedbacks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DriverFeedbacks_AspNetUsers_DriverId",
                        column: x => x.DriverId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_DriverFeedbacks_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_DriverFeedbacks_Requests_RequestId",
                        column: x => x.RequestId,
                        principalTable: "Requests",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "HospitalFeedbacks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    HospitalId = table.Column<int>(type: "int", nullable: false),
                    RequestId = table.Column<int>(type: "int", nullable: false),
                    Rate = table.Column<int>(type: "int", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_HospitalFeedbacks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_HospitalFeedbacks_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_HospitalFeedbacks_Hospitals_HospitalId",
                        column: x => x.HospitalId,
                        principalTable: "Hospitals",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_HospitalFeedbacks_Requests_RequestId",
                        column: x => x.RequestId,
                        principalTable: "Requests",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ParamedicFeedbacks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ParamedicId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    RequestId = table.Column<int>(type: "int", nullable: false),
                    Rate = table.Column<int>(type: "int", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ParamedicFeedbacks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ParamedicFeedbacks_AspNetUsers_ParamedicId",
                        column: x => x.ParamedicId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ParamedicFeedbacks_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ParamedicFeedbacks_Requests_RequestId",
                        column: x => x.RequestId,
                        principalTable: "Requests",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "RequestEvents",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RequestId = table.Column<int>(type: "int", nullable: false),
                    EventType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: false),
                    AmbulanceId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RequestEvents", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RequestEvents_Ambulances_AmbulanceId",
                        column: x => x.AmbulanceId,
                        principalTable: "Ambulances",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_RequestEvents_Requests_RequestId",
                        column: x => x.RequestId,
                        principalTable: "Requests",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_DriverFeedbacks_DriverId",
                table: "DriverFeedbacks",
                column: "DriverId");

            migrationBuilder.CreateIndex(
                name: "IX_DriverFeedbacks_RequestId",
                table: "DriverFeedbacks",
                column: "RequestId");

            migrationBuilder.CreateIndex(
                name: "IX_DriverFeedbacks_UserId",
                table: "DriverFeedbacks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_HospitalFeedbacks_HospitalId",
                table: "HospitalFeedbacks",
                column: "HospitalId");

            migrationBuilder.CreateIndex(
                name: "IX_HospitalFeedbacks_RequestId",
                table: "HospitalFeedbacks",
                column: "RequestId");

            migrationBuilder.CreateIndex(
                name: "IX_HospitalFeedbacks_UserId",
                table: "HospitalFeedbacks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ParamedicFeedbacks_ParamedicId",
                table: "ParamedicFeedbacks",
                column: "ParamedicId");

            migrationBuilder.CreateIndex(
                name: "IX_ParamedicFeedbacks_RequestId",
                table: "ParamedicFeedbacks",
                column: "RequestId");

            migrationBuilder.CreateIndex(
                name: "IX_ParamedicFeedbacks_UserId",
                table: "ParamedicFeedbacks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestEvents_AmbulanceId",
                table: "RequestEvents",
                column: "AmbulanceId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestEvents_RequestId",
                table: "RequestEvents",
                column: "RequestId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DispatchAlerts");

            migrationBuilder.DropTable(
                name: "DriverFeedbacks");

            migrationBuilder.DropTable(
                name: "HospitalFeedbacks");

            migrationBuilder.DropTable(
                name: "ParamedicFeedbacks");

            migrationBuilder.DropTable(
                name: "RequestEvents");
        }
    }
}
