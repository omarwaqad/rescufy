using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddPricingFeedbackAmbulancePoints : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "StartingPrice",
                table: "Hospitals",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<string>(
                name: "AmbulanceNumber",
                table: "Ambulances",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "AmbulancePointId",
                table: "Ambulances",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "StartingPrice",
                table: "Ambulances",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.CreateTable(
                name: "AmbulancePoints",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Latitude = table.Column<decimal>(type: "decimal(9,6)", precision: 9, scale: 6, nullable: false),
                    Longitude = table.Column<decimal>(type: "decimal(9,6)", precision: 9, scale: 6, nullable: false),
                    Address = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AmbulancePoints", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Feedbacks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    HospitalId = table.Column<int>(type: "int", nullable: true),
                    AmbulanceId = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Feedbacks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Ambulances_AmbulanceId",
                        column: x => x.AmbulanceId,
                        principalTable: "Ambulances",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Feedbacks_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Hospitals_HospitalId",
                        column: x => x.HospitalId,
                        principalTable: "Hospitals",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Ambulances_AmbulanceNumber",
                table: "Ambulances",
                column: "AmbulanceNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ambulances_AmbulancePointId",
                table: "Ambulances",
                column: "AmbulancePointId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_AmbulanceId",
                table: "Feedbacks",
                column: "AmbulanceId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_HospitalId",
                table: "Feedbacks",
                column: "HospitalId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_UserId",
                table: "Feedbacks",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ambulances_AmbulancePoints_AmbulancePointId",
                table: "Ambulances",
                column: "AmbulancePointId",
                principalTable: "AmbulancePoints",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Ambulances_AmbulancePoints_AmbulancePointId",
                table: "Ambulances");

            migrationBuilder.DropTable(
                name: "AmbulancePoints");

            migrationBuilder.DropTable(
                name: "Feedbacks");

            migrationBuilder.DropIndex(
                name: "IX_Ambulances_AmbulanceNumber",
                table: "Ambulances");

            migrationBuilder.DropIndex(
                name: "IX_Ambulances_AmbulancePointId",
                table: "Ambulances");

            migrationBuilder.DropColumn(
                name: "StartingPrice",
                table: "Hospitals");

            migrationBuilder.DropColumn(
                name: "AmbulanceNumber",
                table: "Ambulances");

            migrationBuilder.DropColumn(
                name: "AmbulancePointId",
                table: "Ambulances");

            migrationBuilder.DropColumn(
                name: "StartingPrice",
                table: "Ambulances");
        }
    }
}
