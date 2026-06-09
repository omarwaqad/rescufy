using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddIsActiveToAmbulance : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DiagnosedYear",
                table: "ChronicDiseases");

            migrationBuilder.AddColumn<DateTime>(
                name: "DiagnosedDate",
                table: "ChronicDiseases",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Ambulances",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DiagnosedDate",
                table: "ChronicDiseases");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Ambulances");

            migrationBuilder.AddColumn<int>(
                name: "DiagnosedYear",
                table: "ChronicDiseases",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
